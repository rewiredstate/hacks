def stub_uploaded_image(filename = 'image.jpg')
  Project.stub!(:has_attached_file).with(:image).and_return(true)
  File.new("spec/fixtures/paperclip/#{filename}")
end

def stub_uploaded_file(filename = 'image.jpg', filetype = 'image/jpg')
  Rack::Test::UploadedFile.new("spec/fixtures/paperclip/#{filename}", filetype)
end