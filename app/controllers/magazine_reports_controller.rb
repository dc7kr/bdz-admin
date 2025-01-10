class MagazineReportsController < AuthenticatedNonResourceController
  def calendar
    @concerts = Concert.public
    @ensemble_concerts = EnsembleConcert.includes(:ensemble).public
    @courses = Course.public
    @festivals = Festival.public
    @person_members = PersonMember
                      .filename = 'test.ods'
    @rep = MagazineCalendarReport.new('/tmp/' + filename, @concerts, @ensembles, @courses, @festivals)

    send_file('/tmp/' + filename, filename: filename, type: 'application/octet-stream')
    flash[:notice] = 'Export complete!'
    nil
  end
end
