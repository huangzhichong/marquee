class Admin::DreSlideShowController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!

  def configure
    @slides = YAML::load_file(File.join(Rails.root, 'public', 'settings', 'dre_slides_show.yml'))
    @slide_candidates = YAML::load_file(File.join(Rails.root, 'public', 'settings', 'dre_slides.yml'))
    @slide_candidates = @slide_candidates - @slides
  end

  def update
    @slide_candidates = YAML::load_file(File.join(Rails.root, 'public', 'settings', 'dre_slides.yml'))
    @slides = []
    params[:slides].each do |slide_title|
      unless slide_title.empty?
        slide = @slide_candidates.find{|candidate| candidate[:title] == slide_title}
        @slides << slide unless slide.nil?
      end
    end

    File.open(File.join(Rails.root, 'public', 'settings', 'dre_slides_show.yml'), 'w') do |f|
      YAML::dump(@slides, f)
    end

    redirect_to admin_dre_slide_show_configure_path
  end

end
