describe('Name', function($injector){
  var Name, Week, d;

  beforeEach(module('ooApp'));
  beforeEach(module('ooCalendar'));

  beforeEach(inject(function(_Name_, _Week_){
    Name = _Name_;
    Week = _Week_;
    d = new Date();
  }));

  afterEach(function(){
    Name = Week = d = null;
  });

  describe('page()', function(){
    var name, parsed_name, year, month, day;

    beforeEach(function(){ 
      name = Name.page(d);
      year = parseInt(name.slice(0, 4), 10);
      // Javascript counts months 0-11
      month = parseInt(name.slice(4, 6), 10) - 1;
      day = parseInt(name.slice(6, 8), 10);
      parsed_name = new Date(year, month, day);
    });

    afterEach(function(){
      name = parsed_name = year = month = day = null;
    });

    it('returns a string', function(){
      expect(typeof name).toEqual("string");
    });
   
    it('outputs a date string with format YYYYMMDD', function(){
      expect(Math.abs(year - d.getFullYear()) <= 1).toBe(true);
      expect(Math.abs(month - d.getMonth()) <= 1 || month > 11).toBe(true);
      expect(Math.abs(day - d.getDate()) <= 6 || day > 22).toBe(true);
    });

    it('picks the right week bounding the input day', function(){
      var six_days_later = new Date();
      var offset = parsed_name.getDate() + 6;
      six_days_later.setDate(offset);
      parsed_name.setHours(0,0,0,0);

      expect(d >= parsed_name && d <= six_days_later).toBe(true);
    });

    it('gives a Sunday', function(){
      expect(parsed_name.getDay()).toEqual(0);
    });
  });
});