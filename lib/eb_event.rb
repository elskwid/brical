module Brical

  # little helper object to hide/handle the parsing of EventBrite events
  class EbEvent
    
    attr_reader :entry,
                :raw_content,
                :stripped_content,
                :content,
                :id,
                :published,
                :updated,
                :title,
                :summary,
                :content,
                :links,
                :when,
                :where,
                :start,
                :end
                

    # takes an atom feed object
    def initialize(entry)
      @entry            = entry
      @raw_content      = entry.content.value
      @stripped_content = @raw_content.gsub(/<br\s?\/?>/,"\n").gsub(/<\/?[^>]*>/, "")
      @content          = @raw_content
      @id               = entry.id ? entry.id.strip : ""
      @published        = entry.published
      @updated          = entry.updated
      @title            = entry.title ? entry.title.strip : ""
      @links            = entry.links
      parse_when
      parse_where
      parse_details #summary
      parse_dates
    end
    
    def to_s
      s = ""
      s << "id: #{id}\n"
      s << "title: #{title}\n"
      s << "summary: #{summary}\n"
      s << "published: #{published}\n"
      s << "links: #{@entry.links}\n"
      s << "when: #{@when}\n"
      s << "where: #{@where}\n"
      s << "dtstart: #{@start}\n"
      s << "dtend: #{@end}\n"
      s << "updated: #{updated}\n"
      s << "description: #{raw_content}\n"
      s
    end
    
    def to_html
      s = "<ul>"
      s << "<li>id: #{id}</li>"
      s << "<li>title: #{title}</li>"
      s << "<li>summary: #{summary}</li>"
      s << "<li>published: #{published}</li>"
      s << "<li>links: #{@entry.links}</li>"
      s << "<li>when: #{@when}</li>"
      s << "<li>where: #{@where}</li>"
      s << "<li>start: #{@start}</li>"
      s << "<li>end: #{@end}</li>"
      s << "<li>updated: #{updated}</li>"
      s << "<li>description:<br> #{raw_content}</li>"
      s << "</ul>"
      s
    end    
    private
      def parse_when
        eb_when = /When:.*\s([()\w,\s:-]*)Where:/.match(@stripped_content)[1]
        @when = eb_when ? eb_when.strip : "Unknown"
      end
      
      def parse_where
        eb_where = /Where:.*\s*([\s\S]*)Hosted By:/.match(@stripped_content)[1]
        @where = eb_where ? eb_where.strip : "Unknown"
      end

      def parse_details
        details = /Event Details:([\s\S]*)\z/.match(@stripped_content)[1]
        @summary = details ? details.strip : "Unknown"
      end
        
      def parse_dates
        dates =  /When:.*\s([\w,\s]*)from([\d:\sAMP]*)-([\d:\sAMP]*)\((\w+)\)/i.match(@stripped_content)
        if dates
            # dates[1] = day and date
            # dates[2] = start time
            # dates[3] = end time
            # dates[4] = timezone
            @start = DateTime.parse("#{dates[1].strip} #{dates[2].strip}")
            @end = DateTime.parse("#{dates[1].strip} #{dates[3].strip}")
        else
          dates = /When:.*\s([\w,\s]*)at([\d:\sAMP]*)-([\w,\s]*)at([\d:\sAMP]*)\((\w+)\)/i.match(@stripped_content)
          if dates
            # dates[1] = start day and date
            # dates[2] = start time
            # dates[3] = end day and date
            # dates[4] = end time
            # dates[5] = time zone
            @start = Time.parse("#{dates[1].strip} #{dates[2].strip}")
            @end = Time.parse("#{dates[3].strip} #{dates[4].strip}")
          else
            # don't know this format
            @start = ""
            @end = ""
          end
        end
      end
      
  end  
  
end