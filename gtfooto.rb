require 'rubygems'
require 'octokit'
require 'oily_png'
require 'open-uri'
require 'RMagick'
require 'sinatra'

get '/:user/?' do
  @user = Octokit.user params[:user]

  # create a local JPG
  open("public/original_avatars/#{@user.login}.jpg", 'wb') do |file|
    file << open(@user.avatar_url).read
  end

  # convert JPG to PNG
  png_image = Magick::Image.read("public/original_avatars/#{@user.login}.jpg").first
  png_image.format = "PNG"
  png_image.write("public/original_avatars/#{@user.login}.png")

  # add user profile to background (724x327)
  background = ChunkyPNG::Image.from_file("public/original_avatars/#{@user.login}.png")
  profile_image = ChunkyPNG::Image.from_file("public/overlay.png")
  background.compose!(profile_image, 0, 0)
  background.save("public/#{@user.login}-ooto.png", :fast_rgba)
end
