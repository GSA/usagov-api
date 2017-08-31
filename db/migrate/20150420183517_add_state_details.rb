class AddStateDetails < ActiveRecord::Migration
  def change

    create_table :state_details do |t|
      t.integer :node_id
      t.string :title
      t.text :html
      t.string :state_details_page

      t.string :state_homepage_text
      t.string :state_homepage_url

      t.string :governor
      t.string :governor_contact_text
      t.string :governor_contact_url


      t.string :state_contact_text
      t.string :state_contact_url

      t.string :nickname
      t.string :capital

      t.string :state_motto

      t.string :state_symbols_text
      t.string :state_symbols_url

      t.string :agriculture_department_text
      t.string :agriculture_department_url

      t.string :alcoholic_beverage_control_text
      t.string :alcoholic_beverage_control_url

      t.string :attorney_general_text
      t.string :attorney_general_url

      t.string :authentication_office_text
      t.string :authentication_office_url

      t.string :consumer_protection_office_text
      t.string :consumer_protection_office_url

      t.string :corrections_department_text
      t.string :corrections_department_url

      t.string :district_attorneys_text
      t.string :district_attorneys_url

      t.string :education_department_text
      t.string :education_department_url

      t.string :election_office_text
      t.string :election_office_url

      t.string :emergency_management_agency_text
      t.string :emergency_management_agency_url

      t.string :fish_and_wildlife_agency_text
      t.string :fish_and_wildlife_agency_url

      t.string :forestry_department_text
      t.string :forestry_department_url

      t.string :gaming_commision_text
      t.string :gaming_commision_url

      t.string :health_department_text
      t.string :health_department_url

      t.string :health_department_text
      t.string :health_department_url

      t.string :lottery_results_text
      t.string :lottery_results_url

      t.string :maps_text
      t.string :maps_url

      t.string :motor_vehicle_offices_text
      t.string :motor_vehicle_offices_url

      t.string :photos_and_multimedia_text
      t.string :photos_and_multimedia_url

      t.string :racing_commission_text
      t.string :racing_commission_url

      t.string :state_defense_force_text
      t.string :state_defense_force_url

      t.string :surplus_property_sales_text
      t.string :surplus_property_sales_url

      t.string :travel_tourism_text
      t.string :travel_tourism_url

      t.string :language_text
      t.string :language_url
    end
  end
end
