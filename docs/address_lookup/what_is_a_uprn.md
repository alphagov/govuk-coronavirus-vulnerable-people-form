# What is a UPRN?

In order to understand what a Unique Property Reference Number (UPRN) is and why they are required, it is useful to appreciate how postcodes function, and why they alone cannot perform the task of uniquely identifying an individual mail delivery point.

Postcodes are made up of 2 sets of alphanumeric characters, commonly separated by a space.  An example would be `SW1A 2AA`.  Each part of a postcode indicates a zone.  Let's break our example down and see what each element does...

  * Outward code - used to identify the correct postal delivery office
    - _Area_: __SW__ one or two alphanumeric characters that sub-divides the country.
    - _District_: __1A__ one or two alphanumeric characters that sub-divides the area.


  * Inward code - used tell the postal delivery office which delivery round the address is on
    - _Sector_: __2__ one numeric character that sub-divides the district.
    - _Unit_: __AA__ two alphanumeric characters that sub-divides the sector.

This gives a potential total of 3,732,480 available postcodes across the United Kingdom.  The actual number of in-use postcodes is far lower.

Once allocated postcodes do not remain in place indefinitely. On average, 2750 new postcodes are created and 2500 postcodes are terminated each month. So, how do postcodes get allocated? They are allocated based on the volume of inbound post. The DVLA for example, has several postcodes - one per department.

As allocation is based on mail volume, postcodes can cover everything from an individual house (e.g. 10 Downing Street), an entire building (e.g. 10 Whitechapel High Street), up to a large area or region.  So, they alone do not always uniquely identify a distinct mail delivery point. It is possible to use the first line of an address (plus the postcode) to compensate for this, but there is a better way. Each delivery point is allocated a UPRN (an integer of up to 12 digits).

Because they identify a unique delivery point, UPRN's are used - and in some cases, required by various organisations (e.g. health and other local authorities) and companies (e.g. supermarkets, distributors and logistics companies). This is why their use within the vulnerable people service is highly desirable.
