nycstreetsweep
==============

NYC Street Sweep will revolutionize the world of street sign notifications in the greatest city in the World.

NYC StreetSweep is a web application that displays when street cleaning regulations go into effect.  Enter Main and Cross-street information to retrieve the corresponding regulation. Request a text message or twitter reminder to move your car at a preset interval before street cleaning regulation goes into effect. NYC StreetSweep is currently limited to Manhattan only.

Tagline: 
 • Street cleaning reminders made simple.
 • Avoid the dreaded orange ticket.

Basic Application Functionality:
 1) User enters location of their parked car.
 2) Polyline map is generated displaying car location. 
 3) User may request an sms/twitter reminder to move car before regulation starts.
 
Source data:
• NYCDOT database (accessible for download @ https://nycopendata.socrata.com/‎)
• Alternate Side Street Parking regulations.
• Street location by Main and Cross-street designation.

Assumptions:
• Any given ordinance number has one unique regulation description.
• Weekdays and time designations are standardized to enable reminder schedules.
• Street locations as defined by NYCDOT may be geocoded to enable mapping function.

Gems used:
• Geocoder
• Sqlite3
• Sinatra
• Timeliness
• Twilio-Ruby
• Twitter





