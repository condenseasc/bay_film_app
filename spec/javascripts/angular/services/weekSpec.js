describe('Week', function($injector){
  var Week, d, week, week_bounds;

  beforeEach(module('ooApp'));
  beforeEach(module('ooCalendar'));

  beforeEach(inject(function( _Week_ ){
    Week = _Week_;
    d = new Date();
  }));

  afterEach(function(){
    Weekday = d = null;
  });

    // function sharedBehaviorForWeekFunction(context){
    //   describe("(shared)", function(){
  
    //   });
    // }

  describe('days()', function(){
    beforeEach(function(){ week = Week.days(d); });
    afterEach(function(){ week = null; });
    
    it('returns a 7 item array', function(){
      expect(week.length).toEqual(7);
    });

    it('returns Date objects', function(){
      expect(week.every(function(element, index, array){
        return (element.date instanceof Date);
      })).toBe(true);
    });

    it('selects the input day', function(){
      var selection = [];
      for (var i = week.length - 1; i >= 0; i--) {
        if (week[i].selected){
          selection.push(week[i]);
        }
      }

      expect(selection.length).toEqual(1);
      expect(selection[0].date).toEqual(d);
    });

    it('starts on Sunday', function(){
      expect(week.shift().date.getDay()).toEqual(0);
    });

    it('ends on Saturday', function(){
      expect(week.pop().date.getDay()).toEqual(6);
    });
  });

  describe('weekBounds()', function(){
    beforeEach(function(){ week_bounds = Week.bounds(d); });
    afterEach(function(){ week_bounds = null; });

    it('returns a two item array', function(){
      expect(week_bounds.length).toEqual(2);
    });

    it('returns Date objects', function(){
      expect(week_bounds.every(function(element, index, array){
        return (element instanceof Date);
      })).toBe(true);
    });

    it('returns a Sunday at [0] and a Saturday at [1]', function(){
      expect(week_bounds[0].getDay()).toEqual(0);
      expect(week_bounds[1].getDay()).toEqual(6);
    });

    it('bounds the given date', function(){
      expect(d >= week_bounds[0] && d <= week_bounds[1]).toBe(true);
    });
  });

  describe('nextWeek()', function(){
    beforeEach(function(){ week = Week.nextWeek(d); });
    afterEach(function(){ week = null; });

    it('returns a 7 item array', function(){
      expect(week.length).toEqual(7);
    });

    it('returns Date objects', function(){
      expect(week.every(function(element, index, array){
        return (element.date instanceof Date);
      })).toBe(true);
    });

    it('selects the input day', function(){
      var selection = [];
      for (var i = week.length - 1; i >= 0; i--) {
        if (week[i].selected){
          selection.push(week[i]);
        }
      }

      expect(selection.length).toEqual(1);
      expect(selection[0].date).toEqual(d);
    });

    it('starts on input day', function(){
      expect(JSON.stringify(week[0].date.setHours(0,0,0,0)))
        .toEqual(JSON.stringify(d.setHours(0,0,0,0)));
    });

    it('ends six days later', function(){
      var last_day = week[6].date;
      last_day.setHours(0,0,0,0);

      var offset = d.getDate() + 6;
      var six_days_later = new Date(d);
      six_days_later.setDate(offset);
      six_days_later.setHours(0,0,0,0);

      expect(last_day).toEqual(six_days_later);
    });
  });

  describe('nextSunday()', function(){
    var sunday;
    beforeEach(function(){
      sunday = Week.nextSunday(d);
    });

    it('returns a Sunday', function(){
      expect(sunday.getDay()).toBe(0);
    });

    it('returns a date in the future', function(){
      expect(sunday > d).toBe(true);
    });

    it('gives a Sunday in the next 7 days', function(){
      var date_offset = d.getDate() + 8;
      var week_ahead = new Date();
      week_ahead.setDate(date_offset);
      expect(week_ahead > sunday).toBe(true);
    });
  });

  describe('lastSunday()', function(){
    var sunday;
    beforeEach(function(){
      sunday = Week.lastSunday(d);
    });

    it('returns a Sunday', function(){
      expect(sunday.getDay()).toBe(0);
    });

    it('returns a date in the past', function(){
      expect(sunday < d).toBe(true);
    });

    it('gives a Sunday in the last 13 days', function(){
      var date_offset = d.getDate() - 14;
      var week_back = new Date();
      week_back.setDate(date_offset);

      console.log("week back: "+week_back);
      console.log("sunday: "+sunday);
      expect(week_back < sunday).toBe(true);
    });
  });

  describe('isSameDay()', function() {
    var d1, d2, d3;

    beforeEach(function() {
      d1 = new Date(2014, 3, 1, 0, 1);
      d2 = new Date(2014, 3, 1, 22);
      d3 = new Date(2014, 2, 31, 23, 59);
    });

    it('returns true if date matches regardless of other info', function() {
      expect( Week.isSameDay(d1,d2) ).toBe(true);
    });

    it('does not give false positives', function() {
      expect( Week.isSameDay(d2, d3) ).toBe(false);
    });
  });

  describe('parseDateISO8601', function() {
    var d1, d2, d3, s1, s2, s3;
    beforeEach(function() {
      s1 = '2014-03-01';
      s2 = '2011-03-14';
      s3 = '2014-02-31';

      d1 = new Date(2014, 2, 1);
      d2 = new Date(2011, 2, 14);
      d3 = new Date(2014, 1, 31);
    });

    it('returns Date objects', function() {
      expect(Week.parseDateISO8601(s1) instanceof Date).toBe(true);
    });

    it('parses YYYY-MM-DD correctly with valid date objects', function(){
      var parsed1 = Week.parseDateISO8601(s1);
      var parsed2 = Week.parseDateISO8601(s2);
      var parsed3 = Week.parseDateISO8601(s3);

      expect(Week.isSameDay(parsed1, d1)).toBe(true);
      expect(Week.isSameDay(parsed2, d2)).toBe(true);
      expect(Week.isSameDay(parsed3, d3)).toBe(true);
    });

  });
});