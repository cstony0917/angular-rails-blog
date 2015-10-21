class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  before_action :setup_og
  before_action :setup_cache

  def setup_cache
    expires_in 20.minutes
  end

  def index
    render :template => 'layouts/application.html.erb', :layout => false
  end

  def template

    t = /[a-zA-Z\/]*\.{1}[a-z]*/.match(params[:t]).to_s

    begin
      render :template => "templates/#{t}", :layout => false
    rescue Exception => e
      raise ActionController::RoutingError.new('Not Found')
    end

  end

  def setup_og
    @og = {
      :url         => request.protocol + request.host,
      :title       => "Zack's Blog",
      :description => '什麼都寫的部落格!',
      # :image       => request.protocol[0..-3] + og_img
    }

    @og_images = []


    if robot?
      og_img = ActionController::Base.helpers.asset_path("favicon.png", type: :image)

      if params[:path]
        p = params[:path].split('/').last.to_s

        if p != 0
          require 'redcarpet/render_strip'
          # @post       = Post.find(p)
          @post       = Post.find_by_slug(p)


          # options = {
          #   :no_links            => true,
          #   :no_images           => true,
          #   :space_after_headers => true
          # }
          # description = Redcarpet::Markdown.new(Redcarpet::Render::StripDown, options).render @post.content

          html_content = Nokogiri::HTML(@post.html_content)

          description = ''
          html_content.css('p').map do |p|
            description += p.text
          end

          @og[:url]         = @og[:url] + '/' + params[:path]
          # @og[:title]       = @post.title + " | " + @og[:title]
          @og[:title]       = @post.title
          @og[:description] = description

          image_tags  = html_content.css('img')

          image_tags.each do |i|
            @og_images.push i['src']
          end
        end
      end

      @og_images.push request.protocol[0..-3] + og_img

    end
  end

  def robot?
    m = true

    unless request.env["HTTP_USER_AGENT"] == nil
      m = request.env["HTTP_USER_AGENT"].match(/\(.*https?:\/\/.*\)/)
    end
    # logger.info '!!!!!!!!!!!!!!!'
    # logger.info m
    # logger.info '!!!!!!!!!!!!!!!'

    return m
    # return true
  end

  def sitemap
    @base = request.protocol + request.host

    @posts = Post.all

    render 'layouts/sitemap.builder'
  end


end
