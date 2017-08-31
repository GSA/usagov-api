class Api::V1::StateDetailsController < Api::V1::ApiController
  swagger_controller :state_details, "State Details"

  swagger_api :index do
    summary "Fetches all state details in the system"
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
    begin
      @query = QueryBuilder.new(query_params)
      if @query.valid?
        @query_body = @query.build_query(StateDetail)
        @results = StateDetail.search(@query_body)
        render "index"
      else
        render "error"
      end
    rescue Exception => @e
      render "error"
    end
  end


  swagger_api :show do
    summary "Fetches a specific state detail objects and its associated directory records from the system"
    param :path, :id, :integer, :required, "Return state details and directory records based on id"    
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable   
    response :not_found
  end
  def show
    begin
      @query = QueryBuilder.new({terms_filter: "id:#{params[:id]}"})
      if @query.valid?
        @query_body = @query.build_query(StateDetail)
        @results = StateDetail.search(@query_body)
        query_body = QueryBuilder.new({terms_filter: "state_detail_id:#{params[:id]}"}).build_query(DirectoryRecord)

        @directory_records = DirectoryRecord.search(query_body)
        render "show"
      else
        render "error"
      end
    rescue
      @result = { "exists" => false }
    end
  end

  private

  def query_params
    params.permit(:query, :date_filter, :terms_filter, :result_filter, :page_size, :page, :sort)
  end
end