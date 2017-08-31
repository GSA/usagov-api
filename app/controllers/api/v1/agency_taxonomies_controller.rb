class Api::V1::AgencyTaxonomiesController < Api::V1::ApiController
  swagger_controller :agency_taxonomies, "Agency Taxonomy Terms"

  swagger_api :index do
    summary "Fetches all agency taxonomies in the system"
    param :query, :query, :string, :optional, "Search content based on a string parameter"    
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
      if params[:query]
        @results = AgencyTaxonomy.search(params[:query]).records
      else
        @results = AgencyTaxonomy.all
      end
      @results = @results.includes(:parent,:children).page(params[:page]).per(params[:page_size])
      render "index"
    rescue Exception => @e
      render "error"
    end
  end

  swagger_api :show do
    summary "Fetches a specific taxonomy term from the system"
    param :path, :id, :integer, :required, "Return taxonomy term based on ID"    
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable   
    response :not_found
  end
  def show
    @result = AgencyTaxonomy.find_by(tid: params[:id])
    render "show"
  end

end