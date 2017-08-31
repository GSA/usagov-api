class Api::V1::PagesController < Api::V1::ApiController
  swagger_controller :pages, "Pages"

  swagger_api :index do
    summary "Fetches all pages in the system across USA.gov web properties. Also available in .rss format"
    param :query, :page_size, :integer, :optional, "Number of results per page"
    param :query, :page, :integer, :optional, "Page number"
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
    response :not_found
  end

  def index
    # need to write a method that parses the query parameter, or enforce they do it the way we want
    params[:page_size] = params[:page_size].blank? ? 25 : params[:page_size]
    params[:page] = params[:page].blank? ? 1 : params[:page]

    # We'll want to process the query significantly
    @results = SiteLevelTaxonomy.where(generate_page: true,
      page_type: "generic-content-page").includes(:asset_taxonomies => {:text_assets => :text_asset_asset_taxonomies}).includes(:text_assets).order("asset_last_updated DESC")

    respond_to do |format|
       format.rss { render :layout => false }
       format.json {
        @results = @results.page(params[:page]).per(params[:page_size])
        render "index" }
    end
  end

  swagger_api :usa_gov do
    summary "Fetches all pages belonging to USA.gov. Also available in .rss format"
    param :query, :page_size, :integer, :optional, "Number of results per page"
    param :query, :page, :integer, :optional, "Page number"
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
    response :not_found
  end
  def usa_gov
    params[:page_size] = params[:page_size].blank? ? 25 : params[:page_size]
    params[:page] = params[:page].blank? ? 1 : params[:page]
    @site = "USA.gov"
    # We'll want to process the query significantly
    @results = SiteLevelTaxonomy.where(site_membership: @site, generate_page: true,
      page_type: "generic-content-page").includes(:asset_taxonomies => {:text_assets => :text_asset_asset_taxonomies}).includes(:text_assets).order("asset_last_updated DESC")
    #@results = @results.page(params[:page]).per(params[:page_size])
    respond_to do |format|
       format.rss { render "index", :layout => false }
       format.json {
        @results = @results.page(params[:page]).per(params[:page_size])
        render "index" }
    end
  end

  swagger_api :gobierno_usa_gov do
    summary "Fetches all pages belonging to gobiernoUSA.gov. Also available in .rss format"
    param :query, :page_size, :integer, :optional, "Number of results per page"
    param :query, :page, :integer, :optional, "Page number"
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
    response :not_found
  end
  def gobierno_usa_gov
    params[:page_size] = params[:page_size].blank? ? 25 : params[:page_size]
    params[:page] = params[:page].blank? ? 1 : params[:page]
    @site = "GobiernoUSA.gov"
    # We'll want to process the query significantly
    @results = SiteLevelTaxonomy.where(
      site_membership: @site, generate_page: true, page_type: "generic-content-page").includes(
      :asset_taxonomies => {:text_assets => :text_asset_asset_taxonomies}).includes(:text_assets).order("asset_last_updated DESC")
    #@results = @results.page(params[:page]).per(params[:page_size])
    respond_to do |format|
       format.rss { render "index", :layout => false }
       format.json {
        @results = @results.page(params[:page]).per(params[:page_size])
        render "index" }
    end
  end

  swagger_api :kids_usa_gov do
    summary "Fetches all pages belonging to gobiernoUSA.gov. Also available in .rss format"
    param :query, :page_size, :integer, :optional, "Number of results per page"
    param :query, :page, :integer, :optional, "Page number"
    response :ok, "Success"
    response :not_acceptable, "The request you made is not acceptable"
    response :requested_range_not_satisfiable
    response :not_found
  end
  def kids_usa_gov
    params[:page_size] = params[:page_size].blank? ? 25 : params[:page_size]
    params[:page] = params[:page].blank? ? 1 : params[:page]
    @site = "Kids.gov"
    # We'll want to process the query significantly
    @results = SiteLevelTaxonomy.where(site_membership: @site, generate_page: true,
      page_type: "generic-content-page").includes(:asset_taxonomies => {:text_assets => :text_asset_asset_taxonomies}).includes(:text_assets).order("asset_last_updated DESC")
    #@results = @results.page(params[:page]).per(params[:page_size])
    respond_to do |format|
       format.rss { render "index", :layout => false }
       format.json {
        @results = @results.page(params[:page]).per(params[:page_size])
        render "index" }
    end
  end
end
