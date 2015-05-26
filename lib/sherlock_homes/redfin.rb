module SherlockHomes
  class Redfin < SitePrism::Page

    class BasicInfo < SitePrism::Section
      element :bed, 'table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2)'

      element :baths, 'table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(2) > td:nth-child(2)'
      element :floors, 'table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(3) > td:nth-child(2)'
      element :year_built, 'table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(4) > td:nth-child(2)'
      element :year_renovated, 'table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(5) > td:nth-child(2)'

      element :style, 'table:nth-child(2) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2)'
      element :finished, 'table:nth-child(2) > tbody:nth-child(1) > tr:nth-child(2) > td:nth-child(2)'
      element :unfinished, 'table:nth-child(2) > tbody:nth-child(1) > tr:nth-child(3) > td:nth-child(2)'
      element :total_sqft, 'table:nth-child(2) > tbody:nth-child(1) > tr:nth-child(4) > td:nth-child(2)'
      element :lot_size, 'table:nth-child(2) > tbody:nth-child(1) > tr:nth-child(5) > td:nth-child(2)'
    end

    class TaxInfo < SitePrism::Section
      element :land, 'tr:nth-child(1) > td:nth-child(2)'
      element :additions, 'tr:nth-child(2) > td:nth-child(2)'
      element :total, 'tr:nth-child(3) > td:nth-child(2)'
      element :taxes, 'tr:nth-child(4) > td:nth-child(2)'
    end

    class History < SitePrism::Section
      element :date, 'td:nth-child(1)'
      element :event, 'td:nth-child(2)'
      element :price, 'td:nth-child(3)'
      element :appreciation, 'td:nth-child(4)'
      element :source, 'td:nth-child(5)'
    end

    class Details < SitePrism::Section
      element :group_title, 'div.super-group-title'

      sections :group_content, "div.super-group-content > div" do
        element :title, 'h4.title'
        elements :values, 'li'
      end
    end

    class Schools < SitePrism::Section
      element :name, 'td:nth-child(2)'
      element :type, 'td:nth-child(3)'
      element :grades, 'td:nth-child(4)'
      element :distance, 'td:nth-child(6)'
    end

    class Neighborhood < SitePrism::Section
      element :walk_score,  'div[data-dojo-attach-point=walkScoreNode] div.percentage'
      element :stats_chart, 'div.chart-image > img'

      def stats_chart_url
        "https://www.redfin.com#{stats_chart['src']}"
      end

    end

    element :buy_box, '#buyBoxNode'

    element :description, '.remarks > p:nth-child(1) > span:nth-child(1)'

    section :neighborhood, Neighborhood, 'div[data-dojo-attach-point=neighborhoodPanelContainer] div[data-dojo-attach-point=mainContent]'
    section  :basic_info, BasicInfo, 'div[data-dojo-attach-point=publicRecordsPanelContainer] > div.basic-info > div:nth-child(2)'
    section  :tax_info, TaxInfo, 'div[data-dojo-attach-point=publicRecordsPanelContainer] > div.taxable-value > div:nth-child(2) > table:nth-child(1) > tbody:nth-child(1)'
    sections :history, History, 'div[data-dojo-attach-point=historyTableNode] > table > tbody > tr'
    sections :details, Details, 'div[data-dojo-attach-point=propertyDetailsPanelContainer] > div[data-dojo-attach-point=contentNode] > div:first-child > div'

    sections :schools, Schools, 'div[data-dojo-attach-point=schoolsContent] tr[data-dojo-attach-point=fullSchoolRow]'


  end
end
