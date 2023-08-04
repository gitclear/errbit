class Api::V1::ProblemsController < ApplicationController
  respond_to :json, :xml

  skip_before_action :authenticate_user!
  before_action :require_api_key_or_authenticate_user!

  FIELDS = %w(_id app_id app_name environment message where first_notice_at last_notice_at resolved resolved_at notices_count)

  def show
    result = benchmark("[api/v1/problems_controller/show] query time") do
      begin
        problems_scope.only(FIELDS).find(params[:id])
      rescue Mongoid::Errors::DocumentNotFound
        head :not_found
        return false
      end
    end

    result_hash = result.attributes

    last_notice = result.notices.last
    if last_notice
      result_hash["backtrace"] = last_notice.backtrace.lines.to_a
    end

    respond_to do |format|
      format.any(:html, :json) { render json: result_hash } # render JSON if no extension specified on path
      format.xml { render xml: result_hash }
    end
  end

  def index
    query = {}

    if params.key?(:start_date) && params.key?(:end_date)
      start_date = Time.parse(params[:start_date]).utc
      end_date = Time.parse(params[:end_date]).utc
      query = { :last_notice_at => { "$gte" => start_date }, "$and" => [{ resolved_at: nil }, { last_notice_at: { "$lte" => end_date } }] }
    end

    results = benchmark("[api/v1/problems_controller/index] query time") do
      problems_scope.where(query).only(FIELDS).to_a
    end

    respond_to do |format|
      format.any(:html, :json) { render json: JSON.dump(results.map(&:attributes)) } # render JSON if no extension specified on path
      format.xml { render xml: results }
    end
  end

protected

  def problems_scope
    @app && @app.problems || Problem
  end
end
