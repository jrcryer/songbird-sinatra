require 'mongo_mapper'
require 'uri'
require 'digest/md5'
require './models/url'

configure :development do
  MongoMapper.database = 'mongoshort_dev'
end

configure :test do
  MongoMapper.database = 'mongoshort_test'
end

configure :production do
  MongoMapper.database = 'mongoshort'
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  erb :index
end

post '/' do
  if params[:url] and not params[:url].empty?
    @url = URL.find_or_create(params[:url])
  end
  erb :index
end

get '/:shortcode' do
  url = URL.find_by_url_key(params[:shortcode])
  if url.nil?
    raise Sinatra::NotFound
  else
    redirect url.full_url, 301
  end
end