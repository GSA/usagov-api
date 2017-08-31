class Api::V1::DirectoryRecordsController < Api::V1::ApiController
  swagger_controller :directory_records, "Directory Records"

  swagger_api :index do
    summary "Fetches all directory records in the system"
    param :query, :query, :string, :optional, "Search content based on a string parameter"
    param :query, :date_filter, :date_filter, :optional, "Supports all content updated since a date, or between two dates seperated by a comma"
    param :query, :terms_filter, :term_filter, :optional, "Supports filtering for value of fields using key:value pairs seperated by '::', where values can be commas seperated"
    param :query, :result_filter, :result_filter, :optional, "Filter result fields to provided list, defaults to returning all fields"
    param :query, :page_size, :integer, :optional, "Number of results per page"
    param :query, :page, :integer, :optional, "Page number"
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
    response :not_found
  end

  def index
    # need to write a method that parses the query parameter, or enforce they do it the way we want
    # params[:page_size] = params[:page_size] ? params[:page_size].to_i : DEFAULT_PAGE_SIZE
    # params[:page] = params[:page].to_i
    # params[:from] = params[:page] ? params[:page].to_i * params[:page_size].to_i : DEFAULT_PAGE_FROM
    # We'll want to process the query significantly
    begin
      @query = QueryBuilder.new(query_params)
      if @query.valid?
        @query_body = @query.build_query(DirectoryRecord)
        @results = DirectoryRecord.search(@query_body)
        render "index"
      else
        render "error"
      end
    rescue Exception => @e
      render "error"
    end
  end

  swagger_api :federal do
    summary "Fetches all federal records in the system"
    param :query, :query, :string, :optional, "Search content based on a string parameter"
    param :query, :date_filter, :date_filter, :optional, "Supports all content updated since a date, or between two dates seperated by a comma"
    param :query, :terms_filter, :term_filter, :optional, "Supports filtering for value of fields using key:value pairs seperated by '::', where values can be commas seperated"
    param :query, :result_filter, :result_filter, :optional, "Filter result fields to provided list, defaults to returning all fields"
    param :query, :page_size, :integer, :optional, "Number of results per page"
    param :query, :page, :integer, :optional, "Page number"
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
    response :not_found
  end
  def federal
    params[:terms_filter] = params[:terms_filter] ? params[:terms_filter] + "::directory_type:federal,agency" : "directory_type:federal,agency"
    # We'll want to process the query significantly
    begin
      @query = QueryBuilder.new(query_params)
      if @query.valid?
        @query_body = @query.build_query(DirectoryRecord)
        @results = DirectoryRecord.search(@query_body)
        render "index"
      else
        render "error"
      end
    rescue Exception => @e
      render "error"
    end
  end



  swagger_api :bbb do
    summary "Fetches all better business bureau records in the system"
    param :query, :query, :string, :optional, "Search content based on a string parameter"
    param :query, :date_filter, :date_filter, :optional, "Supports all content updated since a date, or between two dates seperated by a comma"
    param :query, :terms_filter, :term_filter, :optional, "Supports filtering for value of fields using key:value pairs seperated by '::', where values can be commas seperated"
    param :query, :result_filter, :result_filter, :optional, "Filter result fields to provided list, defaults to returning all fields"
    param :query, :page_size, :integer, :optional, "Number of results per page"
    param :query, :page, :integer, :optional, "Page number"
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
    response :not_found
  end
  def bbb
    params[:terms_filter] = params[:terms_filter] ? params[:terms_filter] + "::directory_type:better,business" : "directory_type:better,business"
    # We'll want to process the query significantly
    begin
      @query = QueryBuilder.new(query_params)
      @query_body = @query.build_query(DirectoryRecord)
      @results = DirectoryRecord.search(@query_body)
      render "index"
    rescue Exception => @e
      render "error"
    end
  end

   swagger_api :state do
    summary "Fetches all records tied to a state in the system, also achievable using a terms_filter=state:state_acronym"
    param :path, :state, :string, :required, "Return directory records based on state"
    param :query, :query, :string, :optional, "Search content based on a string parameter"
    param :query, :date_filter, :date_filter, :optional, "Supports all content updated since a date, or between two dates seperated by a comma"
    param :query, :terms_filter, :term_filter, :optional, "Supports filtering for value of fields using key:value pairs seperated by '::', where values can be commas seperated"
    param :query, :result_filter, :result_filter, :optional, "Filter result fields to provided list, defaults to returning all fields"
    param :query, :page_size, :integer, :optional, "Number of results per page"
    param :query, :page, :integer, :optional, "Page number"
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
    response :not_found
  end
  def state
    type_filter = "directory_type:state::state:#{params[:state]}"
    params[:terms_filter] = params[:terms_filter] ? params[:terms_filter] + "::#{type_filter}" : "#{type_filter}"
    # We'll want to process the query significantly
    begin
      @query = QueryBuilder.new(query_params)
      if @query.valid?
        @query_body = @query.build_query(DirectoryRecord)
        @results = DirectoryRecord.search(@query_body)
        render "index"
      else
        render "error"
      end
    rescue Exception => @e
      render "error"
    end
  end

  swagger_api :consumer_agencies do
    summary "Fetches all records representing consumer agencies in the system"
    param :query, :query, :string, :optional, "Search content based on a string parameter"
    param :query, :date_filter, :date_filter, :optional, "Supports all content updated since a date, or between two dates seperated by a comma"
    param :query, :terms_filter, :term_filter, :optional, "Supports filtering for value of fields using key:value pairs seperated by '::', where values can be commas seperated"
    param :query, :result_filter, :result_filter, :optional, "Filter result fields to provided list, defaults to returning all fields"
    param :query, :page_size, :integer, :optional, "Number of results per page"
    param :query, :page, :integer, :optional, "Page number"
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
    response :not_found
  end
  def consumer_agencies
    params[:terms_filter] = params[:terms_filter] ? params[:terms_filter] + "::directory_type:consumer,protection" : "directory_type:consumer,protection"
    # We'll want to process the query significantly
    begin
      @query = QueryBuilder.new(query_params)
      if @query.valid?
        @query_body = @query.build_query(DirectoryRecord)
        @results = DirectoryRecord.search(@query_body)
        render "index"
      else
        render "error"
      end
    rescue Exception => @e
      render "error"
    end
  end

  swagger_api :show do
    summary "Fetches a specific directory record from the system"
    param :path, :id, :integer, :required, "Return directory record based on ID"
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
    response :not_found
  end
  def show
    begin
      @query = QueryBuilder.new({terms_filter: "id:#{params[:id]}"})
      if @query.valid?
        @query_body = @query.build_query(DirectoryRecord)
        @results = DirectoryRecord.search(@query_body)
        render "show"
      else
        render "error"
      end
    rescue
      @result = { "exists" => false }
    end
  end

  swagger_api :autocomplete do
    summary "Powers autocomplete style lookup of names and locations of directory records"
    param :query, :name, :string, :optional, "Search titles based on matching this string"
    param :query, :directory_type, :string, :required, "Matches a type in the directory record"
    param :query, :language, :string, :optional, "Match a English or Spanish directory record, defaults to English"
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
    response :not_found
  end
  def autocomplete
    params[:language] = params[:language] ? params[:language] : "English"
    @results = DirectoryRecord.where(
        directory_type: params[:directory_type]).where(
          language: params[:language]).where(
          "title LIKE ?", "%#{params[:name]}%")
    render :autocomplete
  end

  private

  def query_params
    params.permit(:query, :date_filter, :terms_filter, :result_filter, :page_size, :page, :sort)
  end
end
