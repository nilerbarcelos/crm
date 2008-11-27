xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
	"xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do


    xml.title   "Tasks"
    xml.link    task_url(@tasks)
    xml.description "Tasks...."
    xml.pubDate @tasks.first.created_at.rfc822 if @tasks.any?

    xml.atom(:link, :href => "http://localhost:3000/tasks.rss",
               :rel => "self", :type => "application/rss+xml")

    @tasks.each do |task|
      xml.item do
        xml.title       "Task ##{task.id.to_s} for project #{task.project.name}"
        xml.description task.description
        xml.link        task_url(task)
        xml.pubDate     task.created_at.rfc822
        xml.guid        task_url(task)
      end
    end
  end
end
