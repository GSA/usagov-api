class Api::V1::MultimediaAssetsController < Api::V1::ApiController
  swagger_controller :multimedia_assets, "Multimedia Assets"

  swagger_api :index do
    summary "Fetches all multimedia assets in the system"
    param :query, :query, :string, :optional, "Search content based on a string parameter"    
    param :query, :date_filter, :date_filter, :optional, "Supports all content updated since a date, or between two dates seperated by a comma"
    param :query, :terms_filter, :term_filter, :optional, "Supports filtering for exact value of fields using key:value pairs seperated by '::', where values can be commas seperated"
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
    params[:page_size] = params[:page_size] ? params[:page_size].to_i : DEFAULT_PAGE_SIZE
    params[:page] = params[:page].to_i
    params[:from] = params[:page] ? params[:page].to_i * params[:page_size].to_i : DEFAULT_PAGE_FROM
    # We'll want to process the query significantly
    begin
      @query = QueryBuilder.new(query_params)
      if @query.valid?
        @query_body = @query.build_query(MultimediaAsset)
        @results = MultimediaAsset.search(@query_body)
        render "index"
      else
        render "error"
      end
    rescue Exception => @e
      render "error"
    end
  end

  swagger_api :show do
    summary "Fetches a specific asset"
    param :path, :id, :integer, :required, "Return taxonomy term based on ID"    
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable   
    response :not_found
  end
  def show
    begin
      @query = QueryBuilder.new({terms_filter: "id:#{params[:id]}"})
      if @query.valid?
        @query_body = @query.build_query(MultimediaAsset)
        @results = MultimediaAsset.search(@query_body)
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