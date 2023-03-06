module BlobHelper
  def blob
    ActiveStorage::Blob.create_and_upload!(
      io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
      filename: 'rails_helper.rb',
      content_type: 'application/x-ruby'
    )
  end
end
