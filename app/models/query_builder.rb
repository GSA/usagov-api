class QueryBuilder
  include ActiveModel::Model

  attr_accessor :query, :date_filter, :terms_filter,
  :result_filter, :page_size, :page, :sort

  # a.b:c,d,e::b:e
  validates_format_of :terms_filter, :with => /(\w|\.)+:(\w|\.|,)+(::(\w|\.|,)+:(\w|\.)+)*/i, :allow_nil => true

  # 03-05-1980,03-05-1987
  validates_format_of :date_filter, :with => /\d{4}-\d{1,2}-\d{1,2}(,\d{4}-\d{1,2}-\d{1,2}){0,1}/i, :allow_nil => true
  validate :date_filter, :date_in_range
  # should write validations so we can raise those, instead of errors
  validates_numericality_of :page, :page_size

  validates_format_of :sort, :with => /(\w|\.)+:(asc|desc)+/i, :allow_nil => true

  def initialize(attributes={})
    super
    @page = @page ? @page.to_i : 0
    @page_size = @page_size ? @page_size.to_i : 20
  end

  def sort_jbuilder
    sort_query = []
    # default to updated_at, better populate for everything
    sort = sort ? sort : "updated_at:desc"
    sort.split(',').each do |sort|
      sort_elements = sort.split(":")
      sort_query << { sort_elements[0] => sort_elements[1]}
    end
    sort_query
  end

  def terms_jbuilder
    terms = terms_filter ? terms_filter.downcase.split('::') : [ ]
    terms_filter = {}
    terms.each do |term|
      term_array=term.split(':')
      terms_filter[term_array[0]] = term_array[1].downcase.split(/[\s,\,]/)
    end
    terms_filter
  end

  def date_jbuilder
    date_filters = self.date_filter ? self.date_filter.split(",") : []
    date_range = {}
    if !date_filters.empty?
      date_range[:changed_at] = { }

      date_range[:changed_at][:gte] = Time.parse(date_filters[0]).iso8601  if date_filters[0]
      date_range[:changed_at][:lte] = (Time.parse(date_filters[1])+ (60 * 60 * 24)).iso8601 if date_filters[1]
    end
    date_range
  end

  def date_in_range
    if self.date_filter
      date_filters = self.date_filter.split(",")

      if date_filters[0]
        begin
          Time.parse(date_filters[0])
        rescue
          self.errors.add(:date_filter, "Date is out of range, format is YYYY-MM-DD(,YYYY-MM-DD)")
        end
      end
      if date_filters[1]
        begin
          Time.parse(date_filters[1])
        rescue
          self.errors.add(:date_filter, "Time is out of range, format is YYYY-MM-DD(,YYYY-MM-DD)")
        end
      end
    end
  end

  def build_query(model)
    q = query ? "*#{query}*" : nil
    Jbuilder.encode do |json|
      json.size page_size
      json.from page
      json.sort sort_jbuilder
      json.query do
        json.bool do
          json.must do
            if q
              json.child! do
                json.multi_match do
                  json.query q
                  json.type "phrase_prefix"
                  json.fields model.TEXT_QUERY_FIELDS
                  json.operator "and"
                end
              end
            end
            terms_jbuilder.each do |term|
              json.child! do
                json.terms do
                  json.set! term[0], term[1]
                end
              end
            end
            if !date_jbuilder.empty?
              json.child! do
                json.range do
                  json.merge! date_jbuilder
                end
              end
            end
          end
        end
      end
    end
  end
end
