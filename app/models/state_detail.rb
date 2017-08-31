# == Schema Information
#
# Table name: state_details
#
#  id                               :integer          not null, primary key
#  node_id                          :integer
#  title                            :string(255)
#  html                             :text(65535)
#  state_details_page               :string(255)
#  state_homepage_text              :string(255)
#  state_homepage_url               :string(255)
#  governor                         :string(255)
#  governor_contact_text            :string(255)
#  governor_contact_url             :string(255)
#  state_contact_text               :string(255)
#  state_contact_url                :string(255)
#  nickname                         :string(255)
#  capital                          :string(255)
#  state_motto                      :string(255)
#  state_symbols_text               :string(255)
#  state_symbols_url                :string(255)
#  agriculture_department_text      :string(255)
#  agriculture_department_url       :string(255)
#  alcoholic_beverage_control_text  :string(255)
#  alcoholic_beverage_control_url   :string(255)
#  attorney_general_text            :string(255)
#  attorney_general_url             :string(255)
#  authentication_office_text       :string(255)
#  authentication_office_url        :string(255)
#  consumer_protection_office_text  :string(255)
#  consumer_protection_office_url   :string(255)
#  corrections_department_text      :string(255)
#  corrections_department_url       :string(255)
#  district_attorneys_text          :string(255)
#  district_attorneys_url           :string(255)
#  education_department_text        :string(255)
#  education_department_url         :string(255)
#  election_office_text             :string(255)
#  election_office_url              :string(255)
#  emergency_management_agency_text :string(255)
#  emergency_management_agency_url  :string(255)
#  fish_and_wildlife_agency_text    :string(255)
#  fish_and_wildlife_agency_url     :string(255)
#  forestry_department_text         :string(255)
#  forestry_department_url          :string(255)
#  gaming_commision_text            :string(255)
#  gaming_commision_url             :string(255)
#  health_department_text           :string(255)
#  health_department_url            :string(255)
#  lottery_results_text             :string(255)
#  lottery_results_url              :string(255)
#  maps_text                        :string(255)
#  maps_url                         :string(255)
#  motor_vehicle_offices_text       :string(255)
#  motor_vehicle_offices_url        :string(255)
#  photos_and_multimedia_text       :string(255)
#  photos_and_multimedia_url        :string(255)
#  racing_commission_text           :string(255)
#  racing_commission_url            :string(255)
#  state_defense_force_text         :string(255)
#  state_defense_force_url          :string(255)
#  surplus_property_sales_text      :string(255)
#  surplus_property_sales_url       :string(255)
#  travel_tourism_text              :string(255)
#  travel_tourism_url               :string(255)
#  language                         :string(255)
#  language_field                   :string(255)
#  created_at                       :datetime
#  updated_at                       :datetime
#  changed_at                       :datetime
#

class StateDetail < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :directory_records, :foreign_key => "state_detail_node_id", :primary_key => "node_id"

  TEXT_QUERY_FIELDS = ["title", "nickname", "state_motto"]
  def self.TEXT_QUERY_FIELDS
    TEXT_QUERY_FIELDS
  end
  def as_indexed_json(options = {})
    json = Jbuilder.encode do |json|
      json.id self.node_id
      json.title self.title
      json.source_url self.source_url
      json.nickname self.nickname
      json.state_motto self.state_motto
      json.language self.language_field
      json.capital self.capital
      json.governor self.governor
      json.created_at self.created_at
      json.updated_at self.updated_at
      json.changed_at self.changed_at
      # this handles all these link fields
      StateDetail.column_names.each do |col_name|
        if col_name.include? "_text"
          json.set! col_name, self[col_name]
          json.set! col_name.gsub("_text","_url"), self[col_name.gsub("_text","_url")]
        end
      end
    end
    JSON.parse(json)
  end

  def source_url
    if language_field == "English"
      "https://#{ENV['CMP_USAGOV_HOST']}#{state_details_page}"
    else
      "https://#{ENV['CMP_GOBIERNOGOV_HOST']}#{state_details_page}"
    end
  end
  def self.create_or_update_by_xml(node)
    sd = StateDetail.find_or_create_by(:node_id => node.xpath('.//nid').first.try(:content))
    sd.set_field(node, "title", nil)
#    sd.html = node.xpath('.//html').first.try(:content)       # No field with name "html" in data
    sd.set_field(node, "field_state_details_page", "value")
    sd.set_text_and_url(node, "state_homepage")
    sd.set_field(node, "field_governor", "value")
    sd.set_text_and_url(node, "governor_contact")
#    sd.set_text_and_url(node, "state_contact")                   # No Data
    sd.set_field(node, "field_nickname", nil)
    sd.set_field(node, "field_capital", nil)
    sd.set_field(node, "field_state_motto", nil)
    sd.set_text_and_url(node, "state_symbols")
    sd.set_text_and_url(node, "agriculture_department")
    sd.set_text_and_url(node, "alcoholic_beverage_control")
    sd.set_text_and_url(node, "attorney_general")
    sd.set_text_and_url(node, "authentication_office")
    sd.set_text_and_url(node, "consumer_protection_office")
    sd.set_text_and_url(node, "corrections_department")
    sd.set_text_and_url(node, "district_attorneys")
    sd.set_text_and_url(node, "education_department")
    sd.set_text_and_url(node, "election_office")
    sd.set_text_and_url(node, "emergency_management_agency")
    sd.set_text_and_url(node, "fish_and_wildlife_agency")
    sd.set_text_and_url(node, "forestry_department")
    sd.set_text_and_url(node, "gaming_commision")
    sd.set_text_and_url(node, "health_department")
    sd.set_text_and_url(node, "lottery_results")
    sd.set_text_and_url(node, "maps")
    sd.set_text_and_url(node, "motor_vehicle_offices")
    sd.set_text_and_url(node, "photos_and_multimedia")
    sd.set_text_and_url(node, "racing_commission")
    sd.set_text_and_url(node, "state_defense_force")
    sd.set_text_and_url(node, "surplus_property_sales")
    sd.set_text_and_url(node, "travel_tourism")
    sd.language = node.xpath('.//language').first.try(:content)
    sd.language_field = node.xpath(".//field_language").xpath(".//value").first.try(:content)

    created_at = node.at_xpath('.//created').children.first.try(:content)
    changed_at = node.at_xpath('.//changed').children.first.try(:content)
    sd.created_at = Time.at(created_at.to_i)
    sd.updated_at = Time.at(changed_at.to_i)
    sd.save!
  end

  def set_field(node, field_name, type)
    fn = field_name.clone
    field_name.slice! "field_"
    if type.nil? || type.blank?
      self[field_name] = node.xpath(".//#{fn}").first.try(:content)
    elsif type == "value"
      self[field_name] = node.xpath(".//#{fn}").xpath(".//value").first.try(:content)
    end
  end

  def set_text_and_url(node, field_name)
    fn = "field_"+field_name
    # These conditionals handle typos coming from the xml data.
    if field_name.include? "agriculture_department"
      fn = "field_"+"argriculture_department"
    elsif field_name.include? "emergency_management_agency"
      fn = "field_"+"emergency_management_agenc"
    end
    self[field_name+"_text"] = node.xpath(".//#{fn}").xpath(".//title").first.try(:content)
    self[field_name+"_url"] = node.xpath(".//#{fn}").xpath(".//url").first.try(:content)
  end

   def self.title_and_text(node,field_name)
    {
      text: node.at_xpath(".//#{field_name}").xpath(".//title").first.try(:content),
      url: node.at_xpath("//#{field_name}").xpath(".//url").first.try(:content)
    }
  end

  def self.index_name
    "state_details"
  end

  def self.type
    "state_detail"
  end


  def self.search(body = {})
    ELASTIC_SEARCH_CLIENT.search index: index_name,
        body: body, type: type
  end

  def self.get(params = {})
    ELASTIC_SEARCH_CLIENT.get index: index_name,
      id: params[:id],type: type
  end

end
