class LetterFileRegenerationJob < ApplicationJob

  def perform
    event = params[:event]
    user_id = params[:user_id]
    
    triggered_by = User.find(user_id)

    member_events = MemberEvent.where("event_id = ? and event_type='L'", event)

    pdf_files = Array.new 

    fa = FileArchiveTool.new(DOCS_CONFIG)

    member_events.each do |event |

      path = event.filename.split("/")

      pdf_files << MailingFile.new(path[1],path[1],path[0])
    end

    tmp = Tempfile.new(event)
    tmp = MailingFile.new(event+"_regeneration.pdf",event+"_regeneration.pdf")

    fa.merge_pdfs(pdf_files, tmp)

    AdminNotifier.with(:recipient => triggered_by, :topic => "Letter File Regeneration", :attachment => tmp.to_hash).generic_pdf_notification.deliver_later
  end 
end
