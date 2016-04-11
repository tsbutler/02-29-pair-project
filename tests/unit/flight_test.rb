#As it stands right now, whenever you run the main test, it hits the API.  As 
#we're currently limited in the number of queries we can do per day, we need 
#to figure out how to refactor the process_search method in FlightData.rb so 
#that it uses the response data below.  Additionally, we need to write some 
#more tests now that we've reworked a lot of things.

require 'test_helper'

class FlightTest < Minitest::Test

  def setup

    @user_test = User.new
    @user_test.name = "John Doe"
    @user_test.username = "John Doe"
    @user_test.email = "john_doe@mail.com"
    @user_test.password = "noone"
    @user_test.budget = 2300
    @user_test.save

    @destination_test = Destination.new
    @destination_test.airport_code = "LAX"
    @destination_test.name = "Los Angeles"
    @destination_test.save

    @choice_test = Choice.new
    @choice_test.destination_id = @destination_test.id
    @choice_test.user_id = @user_test.id
    @choice_test.save

    @response_data = {"kind"=>"qpxExpress#tripsSearch",
 "trips"=>
  {"kind"=>"qpxexpress#tripOptions",
   "requestId"=>"egEUZvC2pbOw3L7dZ0NtT3",
   "data"=>
    {"kind"=>"qpxexpress#data",
     "airport"=>
      [{"kind"=>"qpxexpress#airportData", "code"=>"DEN", "city"=>"DEN", "name"=>"Denver International"},
       {"kind"=>"qpxexpress#airportData", "code"=>"LAX", "city"=>"LAX", "name"=>"Los Angeles International"},
       {"kind"=>"qpxexpress#airportData", "code"=>"OMA", "city"=>"OMA", "name"=>"Omaha Eppley Airfield"}],
     "city"=>
      [{"kind"=>"qpxexpress#cityData", "code"=>"DEN", "name"=>"Denver"},
       {"kind"=>"qpxexpress#cityData", "code"=>"LAX", "name"=>"Los Angeles"},
       {"kind"=>"qpxexpress#cityData", "code"=>"OMA", "name"=>"Omaha"}],
     "aircraft"=>
      [{"kind"=>"qpxexpress#aircraftData", "code"=>"753", "name"=>"Boeing 757"},
       {"kind"=>"qpxexpress#aircraftData", "code"=>"CR7", "name"=>"Canadair RJ 700"}],
     "tax"=>
      [{"kind"=>"qpxexpress#taxData", "id"=>"ZP", "name"=>"US Flight Segment Tax"},
       {"kind"=>"qpxexpress#taxData", "id"=>"AY_001", "name"=>"US September 11th Security Fee"},
       {"kind"=>"qpxexpress#taxData", "id"=>"US_001", "name"=>"US Transportation Tax"},
       {"kind"=>"qpxexpress#taxData", "id"=>"XF", "name"=>"US Passenger Facility Charge"}],
     "carrier"=>[{"kind"=>"qpxexpress#carrierData", "code"=>"UA", "name"=>"United Airlines, Inc."}]},
   "tripOption"=>
    [{"kind"=>"qpxexpress#tripOption",
      "saleTotal"=>"USD185.10",
      "id"=>"dSbBnVALjtVLnt3T8ApEB1001",
      "slice"=>
       [{"kind"=>"qpxexpress#sliceInfo",
         "duration"=>292,
         "segment"=>
          [{"kind"=>"qpxexpress#segmentInfo",
            "duration"=>102,
            "flight"=>{"carrier"=>"UA", "number"=>"4866"},
            "id"=>"GmfET45UMB6ku437",
            "cabin"=>"COACH",
            "bookingCode"=>"L",
            "bookingCodeCount"=>9,
            "marriedSegmentGroup"=>"0",
            "leg"=>
             [{"kind"=>"qpxexpress#legInfo",
               "id"=>"LpIQYD-vop0uMlXu",
               "aircraft"=>"CR7",
               "arrivalTime"=>"2016-04-12T18:15-06:00",
               "departureTime"=>"2016-04-12T17:33-05:00",
               "origin"=>"OMA",
               "destination"=>"DEN",
               "duration"=>102,
               "operatingDisclosure"=>"OPERATED BY GOJET AIRLINES DBA UNITED EXPRESS",
               "mileage"=>470,
               "secure"=>true}],
            "connectionDuration"=>42},
           {"kind"=>"qpxexpress#segmentInfo",
            "duration"=>148,
            "flight"=>{"carrier"=>"UA", "number"=>"701"},
            "id"=>"G+hLwis5erHh-8nY",
            "cabin"=>"COACH",
            "bookingCode"=>"L",
            "bookingCodeCount"=>9,
            "marriedSegmentGroup"=>"0",
            "leg"=>
             [{"kind"=>"qpxexpress#legInfo",
               "id"=>"LHFhjrxS2mizDXG+",
               "aircraft"=>"753",
               "arrivalTime"=>"2016-04-12T20:25-07:00",
               "departureTime"=>"2016-04-12T18:57-06:00",
               "origin"=>"DEN",
               "destination"=>"LAX",
               "destinationTerminal"=>"7",
               "duration"=>148,
               "onTimePerformance"=>80,
               "mileage"=>860,
               "meal"=>"Food and Beverages for Purchase",
               "secure"=>true}]}]}],
      "pricing"=>
       [{"kind"=>"qpxexpress#pricingInfo",
         "fare"=>
          [{"kind"=>"qpxexpress#fareInfo",
            "id"=>"An16pZQ/LWBBdynZ+ANY8p15UT4khXHaoJbaPd0uUVSo",
            "carrier"=>"UA",
            "origin"=>"OMA",
            "destination"=>"LAX",
            "basisCode"=>"LAK14AKS"}],
         "segmentPricing"=>
          [{"kind"=>"qpxexpress#segmentPricing",
            "fareId"=>"An16pZQ/LWBBdynZ+ANY8p15UT4khXHaoJbaPd0uUVSo",
            "segmentId"=>"GmfET45UMB6ku437"},
           {"kind"=>"qpxexpress#segmentPricing",
            "fareId"=>"An16pZQ/LWBBdynZ+ANY8p15UT4khXHaoJbaPd0uUVSo",
            "segmentId"=>"G+hLwis5erHh-8nY"}],
         "baseFareTotal"=>"USD155.35",
         "saleFareTotal"=>"USD155.35",
         "saleTaxTotal"=>"USD29.75",
         "saleTotal"=>"USD185.10",
         "passengers"=>{"kind"=>"qpxexpress#passengerCounts", "adultCount"=>1},
         "tax"=>
          [{"kind"=>"qpxexpress#taxInfo",
            "id"=>"US_001",
            "chargeType"=>"GOVERNMENT",
            "code"=>"US",
            "country"=>"US",
            "salePrice"=>"USD11.65"},
           {"kind"=>"qpxexpress#taxInfo",
            "id"=>"AY_001",
            "chargeType"=>"GOVERNMENT",
            "code"=>"AY",
            "country"=>"US",
            "salePrice"=>"USD5.60"},
           {"kind"=>"qpxexpress#taxInfo",
            "id"=>"ZP",
            "chargeType"=>"GOVERNMENT",
            "code"=>"ZP",
            "country"=>"US",
            "salePrice"=>"USD8.00"},
           {"kind"=>"qpxexpress#taxInfo",
            "id"=>"XF",
            "chargeType"=>"GOVERNMENT",
            "code"=>"XF",
            "country"=>"US",
            "salePrice"=>"USD4.50"}],
         "fareCalculation"=>
          "OMA UA X/DEN UA LAX 155.35LAK14AKS USD 155.35 END ZP OMA DEN XT 11.65US 8.00ZP 5.60AY 4.50XF DEN4.50",
         "latestTicketingTime"=>"2016-03-03T23:59-05:00",
         "ptc"=>"ADT"}]}]}}
  end

  def test_get_total_cost
    x = @response_data["trips"]["tripOption"][0]["saleTotal"]
    assert_equal("USD185.10", x)
  end

  def test_process_search
    assert_equal({"LAX" => "USD185.10"}, process_search(@user_test.id))
  end
    
  def test_return_this
    assert_equal(["LAX -- USD185.10"], return_this(@user_test.id))
  end
end



