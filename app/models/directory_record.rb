# == Schema Information
#
# Table name: directory_records
#
#  id                   :integer          not null, primary key
#  node_id              :integer
#  title                :string(255)
#  language             :string(255)
#  alpha_order_name     :string(255)
#  street_one           :string(255)
#  street_two           :string(255)
#  city                 :string(255)
#  state                :string(255)
#  zip                  :string(255)
#  contact_links        :text(65535)
#  description          :text(65535)
#  directory_type       :string(255)
#  donated_money        :string(255)
#  government_branch    :string(255)
#  phone_number         :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  changed_at           :datetime
#  status               :string(255)
#  parent_node_id       :integer
#  state_detail_node_id :integer
#
class DirectoryRecord < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # has_many :directory_record_sites, dependent: :destroy
  # has_many :sites, through: :directory_record_sites

  belongs_to :parent, :class_name => "DirectoryRecord", :foreign_key => "parent_node_id", :primary_key => "node_id"
  has_many :children, :class_name => "DirectoryRecord", :foreign_key => "parent_node_id", :primary_key => "node_id"

  belongs_to :state_detail, :foreign_key => "state_detail_node_id", :primary_key => "node_id"

  TEXT_QUERY_FIELDS = ["title^100", "alpha_order_name^100", "description^5", "directory_type", "government_branch"]
  def self.TEXT_QUERY_FIELDS
    TEXT_QUERY_FIELDS
  end
  ACCENT_FOLDING = { ' '=>'-', 'Š'=>'S', 'š'=>'s', 'Ð'=>'Dj', 'Ž'=>'Z', 'ž'=>'z', 'C'=>'C', 'c'=>'c', 'C'=>'C', 'c'=>'c',
        'À'=>'A', 'Á'=>'A', 'Â'=>'A', 'Ã'=>'A', 'Ä'=>'A', 'Å'=>'A', 'Æ'=>'A', 'Ç'=>'C', 'È'=>'E', 'É'=>'E',
        'Ê'=>'E', 'Ë'=>'E', 'Ì'=>'I', 'Í'=>'I', 'Î'=>'I', 'Ï'=>'I', 'Ñ'=>'N', 'Ò'=>'O', 'Ó'=>'O', 'Ô'=>'O',
        'Õ'=>'O', 'Ö'=>'O', 'Ø'=>'O', 'Ù'=>'U', 'Ú'=>'U', 'Û'=>'U', 'Ü'=>'U', 'Ý'=>'Y', 'Þ'=>'B', 'ß'=>'Ss',
        'à'=>'a', 'á'=>'a', 'â'=>'a', 'ã'=>'a', 'ä'=>'a', 'å'=>'a', 'æ'=>'a', 'ç'=>'c', 'è'=>'e', 'é'=>'e',
        'ê'=>'e', 'ë'=>'e', 'ì'=>'i', 'í'=>'i', 'î'=>'i', 'ï'=>'i', 'ð'=>'o', 'ñ'=>'n', 'ò'=>'o', 'ó'=>'o',
        'ô'=>'o', 'õ'=>'o', 'ö'=>'o', 'ø'=>'o', 'ù'=>'u', 'ú'=>'u', 'û'=>'u', 'ý'=>'y', 'ý'=>'y', 'þ'=>'b',
        'ÿ'=>'y', 'R'=>'R', 'r'=>'r', "'"=>'-', '"'=>'-', '.'=>'-', ','=>'-'  }

  def as_indexed_json(options = {})
    json = Jbuilder.encode do |json|
      json.id self.node_id
      json.source_url self.source_url
      json.title self.title
      json.state_detail_id self.state_detail_node_id
      json.language self.language
      json.alpha_order_name self.alpha_order_name
      json.street_one self.street_one
      json.street_two self.street_two
      json.city self.city
      json.state self.state
      json.zip self.zip
      json.summary self.description
      json.directory_type self.directory_type
      json.donated_money self.donated_money
      json.government_branch self.government_branch
      json.phone_number self.phone_number
      json.contact_links self.contact_links ? CGI.unescapeHTML(self.contact_links) : nil
      json.website_links self.website_links ? CGI.unescapeHTML(self.website_links) : nil
      json.created_at self.created_at
      json.updated_at self.updated_at
      json.changed_at self.changed_at
      if self.parent
        json.parent do
          json.id self.parent.try :node_id
          json.title self.parent.try :title
        end
      else
        json.parent nil
      end
      json.children do
        json.array! self.children do |child|
          json.id child.node_id
          json.title child.title
        end
      end
    end
    JSON.parse(json)
  end

  def self.create_or_update_by_xml(node)
    dr = DirectoryRecord.find_or_create_by(:node_id => node.xpath('.//nid').first.try(:content))
    dr.title = node.xpath('.//title').first.try(:content)
    dr.language = node.xpath('.//field_language').first.try(:content)
    dr.alpha_order_name = node.xpath('.//field_alpha_order_name').xpath('.//value').first.try(:content)
    dr.city = node.xpath('.//field_city').xpath('.//value').first.try(:content)
    dr.contact_links = node.xpath('.//field_contact_links').xpath('.//value').first.try(:content)
    dr.website_links = node.xpath('.//field_website_links').xpath('.//value').first.try(:content)
    dr.description = node.xpath('.//field_description').xpath('.//value').first.try(:content)
    dr.directory_type = node.xpath('.//field_directory_type').xpath('.//value').first.try(:content)
    dr.donated_money = node.xpath('.//field_donated_money').xpath('.//value').first.try(:content)
    dr.government_branch = node.xpath('.//field_government_branch').xpath('.//value').first.try(:content)
    dr.phone_number = node.xpath('.//field_phone_number').xpath('.//value').first.try(:content)
    dr.state = node.xpath('.//field_state').xpath('.//value').first.try(:content)
    dr.street_one = node.xpath('.//field_street_1').xpath('.//value').first.try(:content)
    dr.street_two = node.xpath('.//field_street_2').xpath('.//value').first.try(:content)
    dr.zip = node.xpath('.//field_zip').xpath('.//value').first.try(:content)

    dr.group_by = node.xpath('.//field_group_by').xpath('.//value').first.try(:content)
    dr.notify_marketing_team = node.xpath('.//field_notify_marketing_team').xpath('.//value').first.try(:content)
    dr.scoap_member = node.xpath('.//field_scoap_member').xpath('.//value').first.try(:content)
    dr.show_on_az_index = node.xpath('.//field_show_on_az_index').xpath('.//value').first.try(:content)
    dr.website_links = node.xpath('.//field_website_links').xpath('.//value').first.try(:content)
    dr.acronym = node.xpath('.//field_acronym').xpath('.//value').first.try(:content)
    dr.cfo_agency = node.xpath('.//field_cfo_agency').xpath('.//value').first.try(:content)
    dr.for_use_by_text = node.xpath('.//field_for_use_by_text').xpath('.//value').first.try(:content)

    dr.state_detail_node_id = node.xpath('.//field_state_details').xpath(".//nid").first.try(:content)

    dr.status = status_lookup(node.xpath('.//status').first.try(:content))
    deleted = node.xpath('.//deleted').children.first.try(:content)
    if deleted == "1"
      dr.status = status_lookup("2")
    end
    if dr.government_branch == "Executive"
       dr.government_branch = "Executive Department Sub-Office/Agency/Bureau"
    end
    # dr.sites = []
    # for_use_by_list = node.xpath('.//field_for_use_by_text').xpath(".//value")
    # for_use_by_list.each do |site|
    #   site_name = site.try(:content)
    #   dr.sites << Site.find_or_create_by(value: site_name) if site_name
    # end
    created_at = node.at_xpath('.//created').children.first.try(:content)
    updated_at = node.at_xpath('.//changed').children.first.try(:content)
    changed_at = node.at_xpath('.//changed').children.first.try(:content)
    dr.created_at = Time.at(created_at.to_i)
    dr.updated_at = Time.at(updated_at.to_i)
    dr.changed_at = Time.at(changed_at.to_i)
    #dr.parent_node_id = node.xpath('.//field_parent_record').xpath('.//nid').first.try(:content)
    node.xpath('.//field_parent_record').xpath(".//entity_id").each do |e_id|
      dr.parent_node_id = e_id.try(:content) if dr.node_id.to_s != e_id.try(:content).to_s
    end
    dr.save!
  end

  def source_url
    if self.alpha_order_name
      formatted_alpha_order_name = self.title.chars.map {|ch| ACCENT_FOLDING[ch] ? ACCENT_FOLDING[ch] : ch}
      formatted_alpha_order_name = formatted_alpha_order_name.join.downcase
      formatted_alpha_order_name = formatted_alpha_order_name.gsub(/-{2,}/,'-')

      if self.language == "Spanish"
        "https://#{ENV['CMP_GOBIERNOGOV_HOST']}/agencias-federales/#{formatted_alpha_order_name}"
      else
        "https://#{ENV['CMP_USAGOV_HOST']}/federal-agencies/#{formatted_alpha_order_name}"
      end
    end
  end

  def self.get(params = {})
    ELASTIC_SEARCH_CLIENT.get index: index_name,
      id: params[:id]
  end

  def self.search(body = {})
    ELASTIC_SEARCH_CLIENT.search index: index_name,
        body: body, type: type
  end

  def self.index_name
    "directory_records"
  end

  def self.type
    "directory_record"
  end

end
