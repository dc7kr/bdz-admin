class Adm::LetterFileRegenerationController < AuthenticatedNonResourceController

  include FileArchiveHelper
  def index
    event = params[:event]

    authorize! :member, :edit
    member_events = MemberEvent.where("event_id = ? and event_type='L'", event)

    pdf_files = Array.new 

    member_events.each do |event |

      path = event.filename.split("/")

      pdf_files << MailingFile.new(path[1],path[1],path[0])
    end

    tmp = Tempfile.new(event)

    tmp = MailingFile.new(event+"_regeneration.pdf",event+"_regeneration.pdf")
    merge_pdfs(pdf_files, tmp)

    send_file(tmp.full_path)
  end 
end
