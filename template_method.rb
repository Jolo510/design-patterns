# Problem
# - We have complex code
# - Some where in the middle of the complex code, we need a bit of it to vary depending on the circumstance
# - In the future, we will need it to vary depending on a differnt circumstance

# Bad Approach
# - Use if statements to separate the logic
# - This violates one of the guiding principles for design patterns.
# - Separate out things that channge from those that stay the same

# Solution
# - Use a design pattern that separates the code for the various formats
# - Basic flow stays the same regardless of the different formats
# - Define an abstract class with a master method that performs the basic steps
# - Leaves the the details of each step to a subclass

# Example
# - A program that generates a report in various formats
# - Ex. Plain Text, HTML, PostScript, and more formats in the future
# - Basic flow of generating a report is, output_start, output_head, output_body_start, output_body, output_body_end, output_end
# - Create a subclass for each of the output formats

# Ruby does not support abstract methods or classes. Doesn't fit Ruby's dynamic view of life
# Closest we can get to an abstract class is to raise an exception anyone tries and call our 'abstract' method
class Report
    def initialize(title, text)
        @title = title      # 'Monthly Earnings Report'
        @text = text        # ['Active Income: 2000', 'Passive Income: 200']
    end

    def output_report
        output_start
        output_head
        output_body_start
        output_body
        output_body_end
        output_end
    end

    def output_start
        raise 'Called abstract method: #output_start'
    end

    def output_head
        raise 'Called abstract method: #output_head'
    end
    
    def output_body_start
        raise 'Called abstract method: #output_body_start'
    end
    
    def output_body
        @text.each do |line|
            output_line(line)
        end 
    end

    def output_line(line)
        raise 'Called abstract method: #output_line'
    end
    
    def output_body_end
        raise 'Called abstract method: #output_body_end'
    end
    
    def output_end
        raise 'Called abstract method: #output_end'
    end 
end

class HTMLReport < Report
    def output_start
        puts '<html>'
    end

    def output_head
        puts '  <head>'
        puts "      <title>#{@title}</title>"
        puts '  </head>'
    end

    def output_body_start
        puts '  <body>'
    end

    # Note: Use abstract classes implementation for output_body    

    def output_line(line)
        puts "      <p>#{line}</p>"
    end

    def output_body_end
        puts '  </body>'
    end

    def output_end
        puts '</html>'
    end
end


html_report = HTMLReport.new('Monthly earnings Report', ['Active Income: 4000', 'Passive Income: 400'])
html_report.output_report
puts "\n"

class PlainTextReport < Report
    def output_start
    end

    def output_head
        puts "***** #{@title} *****"
    end

    def output_body_start
    end

    # Note: Use abstract classes implementation for output_body    

    def output_line(line)
        puts line
    end

    def output_body_end
    end

    def output_end
    end
end

plain_text_report = PlainTextReport.new('Monthly earnings Report', ['Active Income: 4000', 'Passive Income: 400'])
plain_text_report.output_report
puts "\n"


# The Abstract Base Class controls the higher-level processing through the template methods. Subclasses simply fill in the details

# Improvements using Hook Methods 
# Some subclasses don't need to implement/override the abstract methods. 
# Instead of the subclasses defining empty methods, a better option is for Abstract Base Class to provide default implementation
# Non-abstract methods that can be overwriteen in the subclasses of the Template Method pattern are called Hook Methods 
# Hook methods permits the subclasses to override the implementation or accept the default implementation

class ReportWithHookMethods
    def initialize(title, text)
        @title = title  
        @text = text
    end

    def output_report
        output_start
        output_head
        output_body_start
        output_body
        output_body_end
        output_end
    end

    def output_body
        @text.each do |line|
            output_line(line)
        end 
    end

    # Hook Method
    def output_start
    end

    # Hook Method with a standard default implementation
    def output_head
        output_line(@title)
    end

    # Hook Method
    def output_body_start
    end

    def output(line)
        raise 'Called abstract method: #output_line'
    end

    # Hook Method
    def output_body_end
    end

    # Hook Method
    def output_end
    end
end

class PlainTextReportWithHookMethods < ReportWithHookMethods
    def output_head
        puts "***** #{@title} *****"
    end

    # Note: Use abstract classes implementation for output_body
    def output_line(line)
        puts line
    end
end

plain_text_report_with_hook_methods = PlainTextReportWithHookMethods.new('Monthly earnings Report', ['Active Income: 4000', 'Passive Income: 400'])
plain_text_report_with_hook_methods.output_report
puts "\n"

# Using and Abusing the Template Method Pattern
# - An evolutionary apporach is best.
# -- Start with one variation, refactor out the methods that will become template methods, create subclass for your first case
# - Worst mistake is to overdo things in an effort to cover every possibilty
# - Avoid creating Template classes that requires each subclass to overrdie a high number of obsecure methods just to cover every possible case
# - Keep it lean. Every abstract/hook method is there for a reason
# - Don't create a template class with a multiude of hook methods that no subclass will override