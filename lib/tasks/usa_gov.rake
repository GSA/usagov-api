require 'digest/hmac'

namespace :usa_gov do

  desc "all nodes"
  task :nodes, [:url] => :environment do |t, args|
    puts "STARTING RAKE TASK NODES- #{Time.now}"
    durl = "https://#{ENV['CMP_DRUPAL_HOST']}/dump-nodes/key/FXMDED5GVZZZFPHOOI5Y/"
    thash = {changed: nil, default_url: durl, paged_count: 1}
    nodes_task(args, thash)
    puts "ENDING RAKE TASK NODES- #{Time.now}"
  end

  desc " nodes changed in 20 minutes"
  task :nodes_changed, [:url]=> :environment do |t, args|
    puts "STARTING RAKE TASK NODES CHANGED- #{Time.now}"
    durl = "https://#{ENV['CMP_DRUPAL_HOST']}/updated-nodes/key/FXMDED5GVZZZFPHOOI5Y/"
    thash = {changed: Time.now - 20.minutes, default_url: durl, paged_count: 0}
    nodes_task(args, thash)
    puts "ENDING RAKE TASK NODES CHANGED- #{Time.now}"
  end

  desc "all taxonomies"
  task :taxonomies, [:url] => :environment do |t, args|
    puts "STARTING RAKE TASK TAXONOMIES- #{Time.now}"
    durl = "https://#{ENV['CMP_DRUPAL_HOST']}/dump-taxonomy/key/FXMDED5GVZZZFPHOOI5Y/"
    thash = {default_url: durl}
    taxonomies_task(args, thash)
    puts "ENDING RAKE TASK TAXONOMIES- #{Time.now}"
  end

  desc "taxonomies changed in 20 inutes"
  task :taxonomies_changed, [:url] => :environment do |t, args|
    puts "STARTING RAKE TASK TAXONOMIES CHANGED- #{Time.now}"
    durl = "https://#{ENV['CMP_DRUPAL_HOST']}/dump-recent-taxonomy/key/FXMDED5GVZZZFPHOOI5Y/"
    thash = {default_url: durl}
    taxonomies_task(args, thash)
    puts "ENDING RAKE TASK TAXONOMIES CHANGED- #{Time.now}"
  end

  desc "force indexes to update"
  task :force_updates, [:url] => :environment do |t, args|
    AssetTaxonomy.__elasticsearch__.refresh_index!
    AssetTaxonomy.import

    AgencyTaxonomy.__elasticsearch__.refresh_index!
    AgencyTaxonomy.import

    SiteLevelTaxonomy.__elasticsearch__.refresh_index!
    SiteLevelTaxonomy.import

    TextAsset.__elasticsearch__.refresh_index!
    TextAsset.import

    DirectoryRecord.__elasticsearch__.refresh_index!
    DirectoryRecord.import

    MultimediaAsset.__elasticsearch__.refresh_index!
    MultimediaAsset.import

    StateDetail.__elasticsearch__.refresh_index!
    StateDetail.import
  end

  def nodes_task(args, task_hash)
    headers = get_header_values
    xml_path = args[:url] || task_hash[:default_url]
    conn = Faraday.new(:url => "https://#{ENV['CMP_DRUPAL_HOST']}",:ssl => {:verify => false}) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.headers["DATE"] = headers[:date]
      faraday.headers["CMPACCESS"]= headers[:secret_key]
    end
    [
      "directory_record_content_type",
      "multimedia_content_type",
      "text_content_type",
      "state_details"
      ].each do |type|
      paged = task_hash[:paged_count]
      stop = false
      broken_items = []
      changed = task_hash[:changed]
      until stop
        begin
          # change to 50 results per request... hopefully exception handling will
          # allow this to fail on individual items and still continue
          xml_doc = conn.get xml_url(xml_path, "#{paged}/50", type, changed)
          doc  = Nokogiri::XML(xml_doc.body)
          items = doc.xpath('//nodes/node')
        rescue Exception => e
          puts "#{e.inspect}"
          puts "#{e.message} - #{xml_url(xml_path,paged)}"
          puts "Check that URL exists. NOTE: This error also happens upon reaching end of RSS stream"
          stop = true
        end
        if items.count > 0
          parse_xml_nodes(items)
          paged += 1
        else
          broken_items << paged
          paged += 1
          stop = true
        end
      end
    end
    if !task_hash[:changed].nil?
      TextAsset.import
      DirectoryRecord.import
      MultimediaAsset.import
      StateDetail.import
    end
  end

  def taxonomies_task(args, task_hash)
    xml_path = args[:url] || task_hash[:default_url]
    stop = false
    headers = get_header_values
    conn = Faraday.new(:url => "https://#{ENV['CMP_DRUPAL_HOST']}",:ssl => {:verify => false}) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.headers["DATE"] = headers[:date]
      faraday.headers["CMPACCESS"]= headers[:secret_key]
    end
    paged = 1
    broken_items = []
    until stop
      begin
        xml_doc = conn.get xml_url(xml_path,"#{paged}/50",nil,nil)
        doc  = Nokogiri::XML(xml_doc.body)
        items = doc.xpath('//taxonomy_term_datas/taxonomy_term_data')
      rescue Exception => e
        puts "#{e.inspect}"
        puts "#{e.message} - #{xml_url(xml_path,paged)}"
        puts "Check that URL exists. NOTE: This error also happens upon reaching end of RSS stream"
        stop = true
      end
      if items.count > 0
        parse_taxonomy_nodes(items)
        paged += 1
      else
        broken_items << paged
        paged += 1
        stop = true
      end
    end
    SiteLevelTaxonomy.all.each do |slt|
      slt.site_membership = slt.top_level_parent.value
      slt.save!
    end
    TextAsset.import
    DirectoryRecord.import
    MultimediaAsset.import
    StateDetail.import
  end

  def xml_url(url, paged,type=nil, node_changed=nil)
    if node_changed.nil?
      if type
        url + "#{paged}?type=#{type}"
      else
        url + "#{paged}"
      end
    else
      url + "#{paged}?changed=-15mins&type=#{type}"
    end
  end

  def get_header_values
    # this value is actually ignored now
    # because of issues keeping php's hmac returning the same results as ruby
    # the site just checks for the presence of the header, and ignores it's value
    headers = {}
    headers[:date] = Time.now.to_date.to_s
    headers[:secret_key] = Base64.encode64(Digest::HMAC.digest(headers[:date], ENV['CMP_DRUPAL_SECRET_KEY'], Digest::SHA1))
    headers
  end

  def parse_xml_nodes(nodes)
    puts "Got Nodes: #{nodes.count}"
    nodes.each do |node|
      begin
        node_type = node.xpath('.//type').first.try(:content)
        if node_type == "multimedia_content_type"
          MultimediaAsset.create_or_update_by_xml(node)
        elsif node_type == "directory_record_content_type"
          DirectoryRecord.create_or_update_by_xml(node)
        elsif node_type == "text_content_type"
          #parse_text_object(node) #ignoring these for now since its already set up off elasticsearch
          TextAsset.create_or_update_by_xml(node)
        elsif node_type == "state_details"
          StateDetail.create_or_update_by_xml(node)
        else
          puts "  !!!!!!!!!!  #{node_type}"
        end
      rescue Exception => e
        puts "#{e.inspect}"
        puts "#{e.message} - SKIPPING NODE"
      end
    end
  end

  def parse_taxonomy_nodes(nodes)
    nodes.each do |node|
      begin
        node_type = node.xpath('.//vocabulary_machine_name').first.try(:content)
        if node_type == "asset_topic_taxonomy"
          AssetTaxonomy.create_or_update_by_xml(node)
        elsif node_type == "site_strucutre_taxonomy"
          SiteLevelTaxonomy.create_or_update_by_xml(node)
        elsif node_type == "agency_tags"
          AgencyTaxonomy.create_or_update_by_xml(node)
        else
          puts " ! ! ! ! ! ! #{node_type}"
        end
      rescue Exception => e
        puts "#{e.inspect}"
        puts "#{e.message} - SKIPPING TERM"
      end
    end
  end

  STATUSES = {
    "0" => "Archived",
    "1" => "Published",
    "2" => "Deleted"
  }
  def status_lookup(integer)
    STATUSES[integer.to_s]
  end
end
