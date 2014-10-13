class ShapeshifterScraper < CalendarScraper 
  HOME_URL = 'http://shapeshifterscinema.com/'
  HOME_EVENTS_SELECTOR = '#upcoming .last'

  EVENTS_TITLE = ''
  EVENTS_TIME = ''
  EVENTS_DESCRIPTION = ''
end