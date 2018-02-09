require 'isps'

# TEST DATA
DefaultStart      = "06.11.2017"  # determines which date is shown as start date 
#DefQueue          = 1171             # or queue id for forecast # Source West 1212 ohne collection
#DefQueueInternal  = 1171              # or queue id for internal deducted calls# Source West 1212 ohne collection
DefErreichbarkeitsQuote = 1.00


# REAL DATA 
#DefaultStart      = nil     # determines which date is shown as start date 
DefQueue          = 1168              # or queue id for forecast # Source West 1212 ohne collection
DefQueueInternal  = 1169              # or queue id for internal deducted calls# Source West 1212 ohne collection
#DefErreichbarkeitsQuote = 0.93


# languages that are supported
English_UK  = ISPS::LANG_ENGLISH_UK
English_US  = ISPS::LANG_ENGLISH_US
French      = ISPS::LANG_FRENCH
German      = ISPS::LANG_GERMAN
Italian     = ISPS::LANG_ITALIAN
Spanish     = ISPS::LANG_SPANISH
Swedish     = ISPS::LANG_SWEDISH
Dutch       = ISPS::LANG_DUTCH
Norwegian   = ISPS::LANG_NORWEGIAN
Portuguese  = ISPS::LANG_PORTUGUESE

SCREEN_DIMENSIONS = [1024, 768]            # Screen size of the Dialog

###############################################################################
## section of preselected values which can be set by customer
###############################################################################
NUMROWS                 =  4    #initial selected value of the drop down list "Number of days"
MAXIMUMDAYS             = 20    #the maximum number of days which can be selected 

NUMDAYS                 =   0   #initial selected value of the drop down list "Time-spans per day""

NUM_PLANNING_UNITS      =   8   #initial selected value value of the drop down list "'Amount of planning units'
MAXIMUM_PLANNING_UNITS  =   10   #the maximum number of planning units which can be selected 

VERSION_FORECAST = 1001
VERSION_PLANNED = 1004
VT_HANDLED_CALLS = 1001 
VT_OFFERED_CALLS = 1002 

DefNumDays              = 4*7     # initial value of the input field  "number of days"
IsWeekdayDependent      = false   # initial value of check box        "Consider each day of the week" 
DefCheckPuOpenings      = false   # initial value of check box        "Observe planning unit's business hours",
DefCheckWrDataAfterCalc = true    # initial value of check box        "Write data after calculation?",
DefStartNextMonday      = true    # determines if the initally shown startdate is the next monday after the current system date (or the DefaultStart - date)
                                  # if the value is false, the current system date (or the DefaultStart)  will be shown as the initital date


DefValueType      = "Calls"              # or value type id
DefValueTypeAht   = "AHT"                # or value type id
DefVersion        = "Standard"           # or version id


#use this default values to initialize all cells of the weekdays. Use either ids or name strings for the drop down boxes
$preselectedValues = Array.new()
  
#one entry per day !
#time intervalls must be a pair (start time / end time ) , Format : hh:mm
TimeIntervals  = 
[   
    ["10:00", "12:00"],   #Monday   / day 1                   
    ["10:00", "12:00"],   #Tuesday  / day 2                      
    ["10:00", "12:00"],   #Wednesday/ day 3                     
    ["10:00", "12:00"],   #Thursday / day 4                               
    [ "8:00", "12:00"],   #Friday   / day 5                            
    ["8:00", "12:00"],                      #Saturday / day 6           
    ["8:00", "12:00"]                       #Sunday   / day 7
]


#preselected  values wich can be set for every planning planning unit
#To set different preselected values for a planning unit do following steps :

#first :  Add a new values into the to the array TimeIntervalsAct0  "Array.new(15,"")
#TimeIntervalsAct0          = [Array.new(15,""),Array.new(15,""), Array.new(15,"")]

# add a new value into the array  $preselectedValues
# $preselectedValues[0] are the default value for planning unit 1 
# $preselectedValues[1] are the default values for planning unit 2 

# if only 2 planninig units are defined, but eg. 4 has been selected by the user
# the preselected values are set as following: 
# preselected values selected planning unit 1 => values from $preselectedValues[0]
# preselected values selected planning unit 2 => values from $preselectedValues[1]
# preselected values selected planning unit 3 => values from $preselectedValues[0]
# preselected values selected planning unit 4 => values from $preselectedValues[0]

# INDEX 0   => Id of planning unit which should be preselected
# INDEX 1   => Id of activity      which should be preselected          
# INDEX 2   => Is a placeholder for moving the requirement if neccessary
# INDEX 3   => Id of queue         which should be preselected          
# INDEX 4   => Id of valuetype     which should be preselected          
# INDEX 5   => Id of version       which should be preselected          
#                          
# example :  [1001, 1002, TimeIntervalsAct0[1], 1, 1001, 101] 

$preselectedValues[0]   = [0, 0, Array.new(15,""), 1174, 0, 0]#Arvato
$preselectedValues[1]   = [0, 0, Array.new(15,""), 1179, 1001, 101]#Convergis
$preselectedValues[2]   = [0, 0, Array.new(15,""), 1176, 1001, 101]#egypt
$preselectedValues[3]   = [0, 0, Array.new(15,""), 1183, 1001, 101]#adecco
$preselectedValues[4]   = [0, 0, Array.new(15,""), 1185, 1001, 101]#amevida
$preselectedValues[5]   = [0, 0, Array.new(15,""), 1184, 1001, 101]#conduent
$preselectedValues[6]   = [0, 0, Array.new(15,""), 1178, 1001, 101]#webhelp
$preselectedValues[7]   = [0, 0, Array.new(15,""), 1177, 1001, 101]#tp


###############################################################################

#constants used in the script  --> do not change !! <--
IndexPlanningUnit  = 0  #planning unit id
IndexActivity      = 1  #actvity id
IndexValues        = 2  #placeholder for requirement, 
IndexQueue         = 3  #qeue id
IndexValueType     = 4  #valuetype id
IndexVersion       = 5  #version id

StartTime   = "timefrom"
EndTime     = "timeto"
Req         = "req"
Checkbox    = "checkb"

POMC_PERCENTAGE   = "0" # Percentage or max calls displayed?
POMC_MAXCALLS     = "1"

#require 'date'

class Script
    include Localize

    ADAY_IN_SECONDS   = 24 * 60 * 60
    MINUTE_IN_SECONDS = 60
    HOUR_IN_SECONDS   = 3600
    DAYS_PER_WEEK     = 7
    PRIMARY_PU        = 0
    USE_PERCENTAGE    = true
    USE_MAXCALLS      = false

    #CSS format parameters
    STYLE_RIGHT200PX   = 'text-align: right; width: 200px'
    STYLE_LEFT200PX    = 'text-align: left; width: 200px'
    STYLE_CENTER200PX  = 'text-align: center; width: 200px'
  
    STYLE_CENTER       = 'text-align: center;'
    STYLE_LEFT         = 'text-align: left;'
    STYLE_RIGHT        = 'text-align: right;'
    STYLE_LEFT50PX     = 'text-align: left;width: 50px'
    
    def onStart
        # Initialise session object
        begin
            session 

            # select here the preselected values in the drop down boxes
            @displayedDays = (args['displaydays']|| NUMDAYS).to_i
            @displayedRows = (args['displayrows']|| NUMROWS).to_i
            @displayedActs = (args['displayacts']|| NUM_PLANNING_UNITS).to_i

            if args['mode']  == nil 
                @weekdaymode = IsWeekdayDependent        
            else
                @weekdaymode = (args['mode'] == "1")
            end

            if (@displayedDays > 7) && (@weekdaymode != IsWeekdayDependent)
                @displayedDays = 7
            end

            findNumRows()
            cacheData()
        rescue => error
            logOutput(tr(ERROR_OCCURRED), true)
            logOutput(error.to_s, true)
            
            raise           
        end
    end #onStart

    def cacheData
        @planUnits = session.planUnits

        # Check system Plan Units
        raise tr(NO_PLAN_UNITS_ERROR_TEXT) unless (@planUnits.length > 0)
        
        # Read Task Types
        taskRep = session.repOf(ISPS::TaskRep)
        @tasks = taskRep.taskTypesWithAccess()

        # Check for length of task list.
        raise tr(NO_TASKTYPES_ERROR_TEXT) unless (@tasks.length > 0)

        # Get the curve rep object.
        @repCurve = session.repOf(ISPS::CurveRep)

		@vtTypes = @repCurve.valueTypes
        # Check system Value Types
        raise tr(NO_VALUETYPES_ERROR_TEXT) unless (@vtTypes.length > 0)
        
        @curves = @repCurve.curves
        # Check system Queues
        raise tr(NO_QUEUES_ERROR_TEXT) unless (@curves.length > 0)
        
        @versions = @repCurve.versions
    end

    def getLsStartDate(aDateString) # get language specific start date

        newDate = Date.today
        
        if (aDateString != nil)

            d = 0, m = 0, y = 0

            case $ISPSLanguage

                when German, Norwegian #german, norwegian
                    d,m,y = aDateString.split('.')
                when English_US # English (US)
                    m,d,y = aDateString.split('/')
                when Dutch # Dutch
                    d,m,y = aDateString.split('-')
                when Swedish
                    y,m,d = aDateString.split('-')
                else # French, Italian, English_UK, Spanish, Portuguese
                    d,m,y = aDateString.split('/')
            end

            raise tr(INVALID_START_DATE) unless (Date.exist?(y.to_i, m.to_i, d.to_i) != nil)

            newDate = Date.new(y.to_i,m.to_i,d.to_i)

        elsif (DefStartNextMonday == true)

            #  Default to start next monday.
            newDate = Date.today + 7 - (Date.today.wday - 1)
        end

        return newDate
    end

    def onView #generates the view
        begin
            @numDays        = (args['nrdays']|| DefNumDays).to_i
            @percentageSet  = (args["radio"] == "radiopercent") 

            t = text tr(THIS_SCRIPT_NAME)
            t.style = STYLE_CENTER
            puts bold t
            buildCommonDialog()         
            buildDialogActivities()
        rescue => error
            logOutput(tr(ERROR_OCCURRED), true)
            logOutput(error.to_s, true)
            
            raise           
        end  
    end #onView

    def onRun #calculates and generates the output
        begin
           @numDays            = (args['nrdays']|| 0).to_i
           @dateStart          = getLsStartDate(args['cdate'])
           @dateEnd            = getLsStartDate(args['enddate'])
           @reqAdd             = (args['reqaddmode'].to_i == 1)
           @addRows            = (args['addrowsmode'].to_i == 1)
           @chkPuOpening       = (args['puopeningmode'].to_i == 1)
           @chkWrDataAfterCalc = (args['writedataaftercalculation'].to_i == 1)
           
           @numDays = @dateEnd-@dateStart+1 if @numDays==0
           
           t       = text bold tr(CALC_RESULT_TEXT)
            t.style = STYLE_CENTER
            puts  cap(t)
            runCalculation()    
          rescue => error
            logOutput(tr(ERROR_OCCURRED), true)
            logOutput(error.to_s, true)
            
            raise           
        end  
    end #onRun
 
    def radio(name,cap,value,checked= false)
            n= 'script_' + name
            BlockTag.new(
                'input',
                {
                    :id=>n,
                    :name=>n,
                    :type=>'radio',
                    :value=>value,
                    :checked=>(checked ? true : false)
                }
            )[cap]
    end #radio
    
  def findNumRows
  
    #initially 0 for all weekdays
    @rowsPerWeekday = Array.new(@displayedDays, 0) #[0,0,0,0,0,0,0]
  end
 
 # Creates a new TD tag and sets style
 
  def newTdWithText(text,textAppendix, translateText, bold, style = nil)
      td      = nil
      newText = nil
      translateText ? newText = tr(text) : newText = text
      
      newText = "%s%s" % [newText, textAppendix ] if (textAppendix != nil)
      newText = bold newText   if bold
      if (style != nil)
         td = BlockTag.new("td",style)[newText]
      else
         td = BlockTag.new("td")[newText]
      end
      return td
  end
  
  def BlockTagNewTd(tdstyle = nil)
      mytd = BlockTag.new("td")
      mytd.style = tdstyle if (tdstyle != nil)
      return mytd
  end

 # Creates a new TR tag and a new TD tag and sets style
  def BlockTagNewTrTd(tdstyle = nil)
        mytr = BlockTag.new("tr")
        mytd = BlockTagNewTd(tdstyle)
        return [mytr,mytd]
  end
  
  #Creates and option element and checks for name or id depending if value is string or number
  def optionStr(value,chkvalue)
    if (chkvalue && (chkvalue.type == String))
      return option(value.id, value.name, value.name == chkvalue)
    else
      return option(value.id, value.name, value.id == chkvalue)
    end#if
  end#def
   
#################################################################################################################################################
# Start Build common dialog #####################################################################################################################
    def buildCommonDialog

          
        #resize dialog via JavaScript
        js = BlockTag.new("script",{:language=>'JavaScript'})
              js << "if (document.body.clientHeight < 600) {"
              js << "if (document.body.clientWidth < 600) {"
              js << "window.resizeTo(#{SCREEN_DIMENSIONS[0]},#{SCREEN_DIMENSIONS[1]});"
              js << "}}"
        puts js
      
      
        displaydays = sel('displaydays')        
        for i in 0 .. MAXIMUMDAYS  
            displaydays<< option(i , i.to_s,i  == @displayedDays)
        end     
        displaydays.onChange = "LoadAgain();"
    
        
        displayacts = sel('displayacts')
        for i in 1 .. MAXIMUM_PLANNING_UNITS
            displayacts << option(i, i.to_s,i  == @displayedActs)
        end

        displayacts.onChange = "LoadAgain();"       
        start_date = getLsStartDate(args['cdate'] || DefaultStart || Date.today.to_s)
        end_date = getLsStartDate(args['enddate'] || start_date.to_s ) + @numDays
                
        
        inpDays  = sel('nrdays')
        inpDays << option(4*7,"4 Wochen",@numDays == 4*7)                
        inpDays << option(5*7,"5 Wochen",@numDays > 4*7)                
        inpDays << option(0,"nach Datum",@numDays < 4*7)                
        inpDays.style = STYLE_RIGHT200PX
        inpDays.onChange = "LoadAgain();"       
        inpStart = inp('cdate', "#{(start_date)}")
        inpStart.style = STYLE_RIGHT200PX
        inpStart.class="date"
        inpStart.onChange = "LoadAgain();"       

        inpEndDate = inp('enddate', "#{(end_date || start_date + @numDays-1)}")
        inpEndDate.style = STYLE_RIGHT200PX
        inpEndDate.class="date"
        inpEndDate.disabled = "true" if (@numDays.to_i >= 4*7) 
        span = BlockTag.new("span")
        span << inpDays
        span << inpEndDate      
        if (args['mode'] != nil)      
            checkPuOpenings = (args['puopeningmode'] == "1") 
            checkWrDataAfterCalc = (args['writedataaftercalculation'] == "1") 
        else
            checkPuOpenings = DefCheckPuOpenings
            checkWrDataAfterCalc = DefCheckWrDataAfterCalc
        end
        
        fs= fieldset(tr(DATE_TEXT))
        
        fs<< ftable( [],
            [
                [],[tr(START_DATE_TEXT)],[],['', nil, inpStart],
                [],["Anzahl Slots"],[],['', nil, displaydays],
                []
            ],
            [
                [],[tr(NUM_OF_DAYS_TEXT)],[],['', nil, span ],
                [],[tr(DISPLAYED_PU_TEXT)],[],['', nil, displayacts],
                []
            ]
            
        )
        
        puts fs
        
        
   end
   
   
   def buildDialogActivities()

        @planUnits.sort!{|x,y| x.name.upcase <=> y.name.upcase} if (@planUnits.length > 1)
        @tasks.sort!{|x,y| x.name.upcase <=> y.name.upcase} if (@tasks.length > 1)
        @vtTypes.sort!{|x,y| x.name.upcase <=> y.name.upcase} if (@vtTypes.length > 1)
        @curves.sort!{|x,y| x.name.upcase <=> y.name.upcase} if (@curves.length > 1)
        @versions.sort!{|x,y| x.name.upcase <=> y.name.upcase} if (@versions.length > 1)
        
        # Now the queue parameters
          fs= fieldset(tr(QUEUE_PARAM_TEXT))
          selQueue= sel('queueid')
          selQueueInternal= sel('queueidinternal')

         argsQueue= args['queueid'] ? args['queueid'].to_i : DefQueue
         argsQueueInternal= args['queueidinternal'] ? args['queueidinternal'].to_i : DefQueueInternal
        @curves.each{|curve|
            selQueue << optionStr(curve,argsQueue)
            selQueueInternal << optionStr(curve,argsQueueInternal)
        }

        argsVT= args['valuetypecall'] ? args['valuetypecall'].to_i : DefValueType
        selVT = sel('valuetypecall')
        @vtTypes.each {|vt|
            if (vt.aggregation == ISPS::CurveValueType::AGG_SUM)
                        selVT << optionStr(vt,argsVT)
            end
        }

        argsVTAHT= args['valuetypeaht'] ? args['valuetypeaht'].to_i : DefValueTypeAht
        selVTAHT= sel('valuetypeaht')
        selVTAHT<< option(-1 ,tr(NO_VALUETYPE_AHT), -1 == @idValueTypeAHT)
        @vtTypes.each {|vt|
            if (vt.aggregation != ISPS::CurveValueType::AGG_SUM)               
                        selVTAHT<< optionStr(vt,argsVTAHT)
            end
        }
 
        argsVersion= args['version'] ? args['version'].to_i : DefVersion
        selVersion= sel('version')
        @versions.each {|version|
                selVersion<< optionStr(version, argsVersion)
        }

        value_type_offered_calls = value_type_handled_calls = nil 
        @vtTypes.each do |vt|
          value_type_offered_calls = vt if vt.id == VT_OFFERED_CALLS
          value_type_handled_calls = vt if vt.id == VT_HANDLED_CALLS          
        end 
        raise "Valuetype not found" unless value_type_offered_calls && value_type_handled_calls
        version_forecast = version_planned = nil 
        @versions.each do |v|
          version_forecast = v if v.id == VERSION_FORECAST
          version_planned = v if v.id == VERSION_PLANNED          
        end 
        raise "Version not found" unless version_forecast && version_planned
        
        fs<< ftable(
            [nil,"Eingehende Anrufe Gesamt", nil, selQueue,nil, "(Wertetyp: #{value_type_offered_calls.name}, Version: #{version_forecast.name})"],
            [nil, "Bearbeitete Anrufe intern", nil, selQueueInternal, nil, "(Wertetyp: #{value_type_handled_calls.name}, Version: #{version_planned.name})"],
            [nil, "Ziel-Erreichbarkeitsquote(EQ)",nil,inp('eq',DefErreichbarkeitsQuote.to_s)  ]
        )
        puts fs
    
    
        #########################
        # Now the planning units 
        #########################
        fs = fieldset(tr(PLANUNIT_PARAM_TEXT))
        t  = BlockTag.new('table',{:style=>'font-size: 10pt;', :width=>"#{(@displayedActs+1)*200}", :border=>"0", :cellspacing=>"0", :cellpadding=>"3"})
        
        trPu,      tdPu      = BlockTagNewTrTd(STYLE_LEFT)
        trAct,     tdAct     = BlockTagNewTrTd(STYLE_LEFT)
        trChk,     tdChk     = BlockTagNewTrTd(STYLE_LEFT)
        trQueue,   tdQueue   = BlockTagNewTrTd(STYLE_LEFT)
        trVt,      tdVt      = BlockTagNewTrTd(STYLE_LEFT)
        trVersion, tdVersion = BlockTagNewTrTd(STYLE_LEFT)

        trPu        << (tdPu      << tr(PU_TEXT))
        trAct       << (tdAct     << tr(ACT_TEXT))        
        trChk       << (tdChk     << tr(WRITE_TO_QUEUE_TEXT))
        trQueue     << (tdQueue   << tr(QUEUE_TEXT))
        trVt        << (tdVt      << tr(VALUETYPE_TEXT))
        trVersion   << (tdVersion << "Ziel Version")
   
        for nPU in (0 ... @displayedActs)
                
            puActComb = $preselectedValues[nPU]
            if $preselectedValues[nPU] == nil
                puActComb = $preselectedValues[0]
            end
            
            argsPu = args['planunitid' + nPU.to_s] ? args['planunitid' + nPU.to_s].to_i : puActComb[IndexPlanningUnit]
              
            selPU= sel('planunitid' + nPU.to_s)
            @planUnits.each{|pu|
                 selPU<< optionStr(pu, argsPu)
            }

            argsAct= args['activity'  + nPU.to_s] ? args['activity'  + nPU.to_s].to_i : puActComb[IndexActivity]

            selAct= sel('activity'  + nPU.to_s)
            @tasks.each{|task|selAct<< optionStr(task, argsAct) }
            
            queueString      = 'tarqueue'   + nPU.to_s
            valTypeString    = 'tarvaltype' + nPU.to_s
            versionString    = 'tarversion' + nPU.to_s

            curveId   = puActComb[IndexQueue]
            vtId      = puActComb[IndexValueType]
            versionId = puActComb[IndexVersion]

            if args['mode'] != nil
                curveId   = args[queueString].to_i
                vtId      = args[valTypeString].to_i
                versionId = args[versionString].to_i
            end

            selTarQueue   = sel(queueString)
            
            @curves.each do |curve|
                selTarQueue<< optionStr(curve, curveId)
            end

            selTarVT= sel(valTypeString)
            @vtTypes.each do |vt|
                    selTarVT<< optionStr(vt, vtId)
            end

            selTarVersion= sel(versionString)
            @versions.each do |version|
                selTarVersion << optionStr(version, versionId)
            end

            tdPu,tdAct  = BlockTagNewTd(STYLE_RIGHT)
            tdAct       = BlockTagNewTd(STYLE_RIGHT)
    
            tdPu  << selPU
            tdAct << selAct
                        
            
            tdQueue   = BlockTagNewTd(STYLE_RIGHT)
            tdVt      = BlockTagNewTd(STYLE_RIGHT)
            tdVersion = BlockTagNewTd(STYLE_RIGHT)
            
            tdQueue   << selTarQueue
            tdVt      << value_type_handled_calls.name
            tdVersion << version_forecast.name
            
             
                                
            trPu      << tdPu
            trAct     << tdAct
            trQueue   << tdQueue
            trVt      << tdVt
            trVersion << tdVersion  
            
        end#For all displayed planning units
        
        t << trQueue << trVt << trVersion
      
        fs << t
        puts fs

        if @displayedDays > 0
            
            fs= fieldset(tr(DIVISION_WORK_TEXT))
            
            # Now the time-spans and work volume division

            trHeader  = BlockTag.new("tr")
            
            radioPercent            = radio("radio", tr(USE_PERCENTAGE_TEXT), "radiopercent", (@percentageSet ) )
            radioPercent.onClick    = "LoadAgain();"
            
            radioMaxCalls           = radio("radio",tr(USE_MAXCALLS_TEXT),"radiovalue" , (!@percentageSet) )
            radioMaxCalls.onClick   = "LoadAgain();"
            fs << radioPercent << BlockTag.new("br") << radioMaxCalls
            
            t = table       
            t = BlockTag.new('table',{:style=>'font-size: 10pt;', :width=>"#{(@displayedActs+1)*200}", :border=>"0"})
            
            #Add Header for begin/end
            tableRow        = BlockTag.new("tr")
     
            tdEmpty  = BlockTagNewTd(STYLE_LEFT50PX)  
            tdTag  = BlockTagNewTd(STYLE_LEFT50PX)
            tdTag   << "Tag"

            tdBegin  = BlockTagNewTd(STYLE_LEFT50PX)
            tdBegin   << tr(BEGIN_TEXT)
            
            tdEnd      = BlockTagNewTd(STYLE_LEFT50PX)
            tdEnd     << tr(END_TEXT)
            tableRow  << tdEmpty << tdTag << tdBegin << tdEnd
      
            
            # Add Header for each planning unit
            
            for iRow in 0...@displayedActs               
            
                tdReq  = BlockTagNewTd(STYLE_CENTER200PX)
                @percentageSet  ? tdReq   << (tr(PERCENTAGE_TEXT) + '  ') : tdReq  << tr(MAXCALLS_TEXT) 
                emptyTd     = BlockTagNewTd(STYLE_LEFT50PX)
                tableRow << tdReq 
            end#for
            
            t <<  tableRow
           
           
            curWeekDay = 0
      
            # For each weekday build the rows
           
            @displayedDays.times do |indexDay|
                
                if (@displayedRows== 0)
                    curWeekDay += 1
                    next
                end

                selSDay= sel('specialday' + indexDay.to_s)
                startdate = getLsStartDate(args['cdate'] || DefaultStart || Date.today.to_s)
                startdate.upto(startdate + @numDays.to_i) do |day|
                     selSDay<< option(day,day.to_s)
                end
                selSDay.style = "width:120px"

                
                tdWeekday  = BlockTagNewTd(STYLE_LEFT50PX)

                tdWeekday << selSDay
                
                trReq  = Array.new (@displayedRows)
                
                rowsPerDay = @displayedRows
                
                
                    trReq = BlockTag.new("tr")         

                    
                    strStartTime = StartTime +  curWeekDay.to_s
                    strEndTime   = EndTime  + curWeekDay.to_s
                    defValStart  = args[strStartTime] 
                    defValEnd    = args[strEndTime]
                    #Prefill
                    
                    defValStart  = TimeIntervals[indexDay][0]     if defValStart == nil && indexDay < TimeIntervals.size
                    defValEnd    = TimeIntervals[indexDay][1] if defValEnd == nil   && indexDay < TimeIntervals.size
                     
                    inpTimeFrom  = inpRight(strStartTime, defValStart,50)
                    inpTimeTo    = inpRight(strEndTime, defValEnd,50)
                    
                    tdBegin      = BlockTagNewTd()
                    tdBegin.style = "width:50px"
                    tdEnd        = BlockTagNewTd()
                    tdEnd.style = "width:50px"
                    
                    tdBegin     << inpTimeFrom
                    tdEnd       << inpTimeTo
                    
                    tdNumbering      = BlockTagNewTd()
                    tdNumbering.style = "width:20px"
                    tdNumbering << (indexDay+1).to_s

                    trReq << tdNumbering
                    trReq << tdWeekday
                    trReq << tdBegin
                    trReq << tdEnd

                    
                    
                    # For each planning unit
                    for curPu in 0...@displayedActs
                    
                        puActComb = $preselectedValues[curPu]
                        if $preselectedValues[curPu] == nil
                            puActComb = $preselectedValues[0]
                        end#if

                        strReq = Req  + curPu.to_s  + '_' + curWeekDay.to_s
                        inpReq = Array.new
                        defValReq = args[strReq]

                        if puActComb[IndexValues][curWeekDay] != nil
                            defValReq   = puActComb[IndexValues][curWeekDay] unless defValReq != nil

                        end#if

                        inpReq = inpRight(strReq, defValReq,50)
                        tdReq  = BlockTagNewTd(STYLE_CENTER200PX)
                        tdReq << inpReq
                        
                        tdReq   << "%" if  @percentageSet

                        trReq << tdReq                 
                        
                    end#for pu
                t << trReq
                curWeekDay  += 1            

            end#each                    
            
            fs << t
            
            puts fs
        end # if displayDays>0
    end#def buildDialog

    ##########################################################################################
    # Do whole calculation in here
    #
    def runCalculation
        session                     # set the $ISPSLanguage variable!
      
        # Read arguments to script
        @idQueue           = (args['queueid']       ||  0).to_i
        @idVersion         = (args['version']       ||  0).to_i
        @idValueType       = (args['valuetypecall'] ||  0).to_i
        @idValueTypeAHT    = (args['valuetypeaht']  || -1).to_i
        @displayDays       = (args['displaydays']   ||  1).to_i
        @displayRowsPerDay = (args['displayrows']   ||  1).to_i
        @percentageSet     = (args["radio"] == "radiopercent") 
        
        @erreichbarkeitsquote = (args['eq'] || 1.0).to_f

        @dateStart = getLsStartDate(args['cdate'])
  
        @percentage        = Array.new()
        detailsTable       = Array.new() # Printout of percentage values/max calls

        
       #Do for each planning unit   
        for nPU in (0 ... @displayedActs)
    

    
           #Copy all Percentage values to array
           perAct = Array.new()
           for days in 0...@displayDays
             perDays = Array.new()
             for rows in 0...@displayRowsPerDay
                strReq = Req  + nPU.to_s  + '_' + days.to_s + '_' + rows.to_s
                perDays[rows] = (args[strReq] || "-1").tr(',', '.').to_f
             end#for rows
             perAct[days]=perDays 
           end#for days
           @percentage[nPU]=perAct
        end#for PUs
        
        # Check percentage values
        if (USE_PERCENTAGE == @percentageSet)
           for days in 0...@displayDays
               valueSum=0
               for nPU in 0...@displayedActs
                 curr = getPercentage(@percentage, nPU, @displayedActs, days,0) #Sets if not set
                 raise tr(PERCENTAGE_LARGER_100_ERROR_TEXT) + " ([#{days+1},#{nPU+1}] = #{curr})" if (curr > 100)
                 valueSum += curr
               end#for nPU
               raise tr(PERCENTAGE_SUM_NOT_100_ERROR_TEXT) + " ([#{days+1}] = #{valueSum})" if valueSum != 100.0 
           end#for days
                    
        end#if USE_PERCENTAGE


        
        
        # Copy Begin/end values for each day to arrays
        @timeslotStart = Array.new()
        @timeslotEnd = Array.new()
        for days in 0...@displayDays
           
           strStartTime = StartTime +  days.to_s
           strEndTime   = EndTime +  days.to_s
           s = timeStringToSeconds( args[strStartTime] || 0)
           e = timeStringToSeconds( args[strEndTime]   || 0)
                     
           #Do first check, Starttime must be smaler end time 
           raise tr(START_LARGER_ENDTIME_ERROR_TEXT) + ": (#{args[strStartTime]} > #{args[strEndTime]} )" if  (s > e) 
           
           # RS XXX Check if start and end time overlaps of different entries

           
           detailsRow = []
           detailsRow[0] = getWeekday(days) #: "")# day
           detailsRow[1] = (args[strStartTime])# Time
           detailsRow[2] = (args[strEndTime])# Time
           for pus in (0 ... @displayedActs)
               detailsRow << ( (@percentage[pus][days]).to_s + ((USE_PERCENTAGE == @percentageSet) ? "%" : ""))
           end#for  
           detailsTable.push(detailsRow)

           @timeslotStart[days] = s
           @timeslotEnd[days] = e  
           end

           
            forecastcurveData           = ISPS::CurveData.new(@repCurve)
            forecastcurveData.curve     = args['queueid'].to_i
            forecastcurveData.valueType = VT_OFFERED_CALLS
            forecastcurveData.version   = VERSION_FORECAST

            internalcurveData           = ISPS::CurveData.new(@repCurve)
            internalcurveData.curve     = args['queueidinternal'].to_i
            internalcurveData.valueType = VT_HANDLED_CALLS
            internalcurveData.version   = VERSION_PLANNED
            
           
        externalcurveData = Array.new(@displayedActs)
        for i in (0 ... @displayedActs)
            externalcurveData[i]           = ISPS::CurveData.new(@repCurve)
            externalcurveData[i].curve     = args['tarqueue' + i.to_s].to_i
            externalcurveData[i].valueType = VT_HANDLED_CALLS
            externalcurveData[i].version   = VERSION_PLANNED
        end#for  

        
 
        puts text "Result:"
        @dateStart.upto(@dateStart + (@numDays - 1)) do |date|
          fs  =  fieldset(bold("#{Localize::WEEKDAYS[date.wday]}, #{date}"))
          externalCapacity = Array.new(@displayedActs)
          forecast         = Array.new(@displayedActs)
          calls_alone      = Array.new(@displayedActs,0)
          oeffnungszeiten  = Array.new(@displayedActs)
          for partner in (0 ... @displayedActs)
              externalcurveData[partner].version   = VERSION_PLANNED
              externalcurveData[partner].date      = date
              externalcurveData[partner].read(0) or raise "Konnte Queue nicht lesen"
              externalCapacity[partner] = externalcurveData[partner].to_a.sum / 100.0
              forecast[partner] = Array.new(48,0)
              oeffnungszeiten[partner] = opening_times(@repCurve,externalcurveData[partner].curve, date)
          end#for
          fs << text("Kapazität der Partner: #{externalCapacity.join(", ")}") 

          # Read forecast curve data
          forecastcurveData.date = date
          forecastcurveData.read(0) or raise "Konnte Queue nicht lesen"

          tagesforecast = forecastcurveData.to_a.sum / 100.0
          fs << text("Tagesforecast: #{round(tagesforecast,0)} Anrufe, damit bei Ziel-EQ #{round(@erreichbarkeitsquote,2)} also #{round(tagesforecast*@erreichbarkeitsquote,0)} Anrufe")

          # Read internal curve data
          internalcurveData.date = date
          internalcurveData.read(0) or raise "Konnte Queue nicht lesen"

          internalhandled = intern_gehandelte_calls(forecastcurveData.to_a,internalcurveData.to_a) / 100.0
          fuer_extern = (tagesforecast*@erreichbarkeitsquote) - internalhandled 
          fuer_extern = 0 if fuer_extern < 0 

          calls_to_distribute = Array.new(48,0.0)

          fs << text("Intern bearbeitet: #{round(internalhandled,0)}, damit uebrig #{round(fuer_extern,0)}")
          if fuer_extern == 0
            fs << text("Alle Calls werden intern gehandled")
          else            
			gesamt_extern = 0
			actual_eq=1.0
            externalCapacity.each {|val| gesamt_extern += val}
            if gesamt_extern >= fuer_extern
			  actual_eq=(gesamt_extern+internalhandled)/tagesforecast.to_f
              fs << text("EQ kann erreicht werden (Es wird eine EQ von #{round(actual_eq,2)} erreicht.)")
            else
			  actual_eq=(gesamt_extern+internalhandled)/tagesforecast.to_f
              fs << text("Extern kann #{round(gesamt_extern,0)} Anrufe bearbeiten, damit erreichbare EQ: #{round(actual_eq,2)}")
            end

                       
            # For each interval
            internalcurveData.to_a.each_index do |i|
              calls_to_distribute[i] = ((forecastcurveData[i]/100.0*actual_eq) - internalcurveData[i]/100.0)
              calls_to_distribute[i] = 0 if calls_to_distribute[i] < 0
			end


          # Berechne Anteil pro Partner

          calls_to_distribute.to_a.each_index do |interval|         
			partners_open = count_partners_open(oeffnungszeiten,interval)
            if partners_open == 1
              for partner in (0 ... @displayedActs)
				calls_alone[partner] += calls_to_distribute[interval] if open_at_interval(oeffnungszeiten[partner],interval)
              end#for
            end 
          end #each_index  

        for partner in (0 ... @displayedActs)
		  calls_alone[partner] = externalCapacity[partner] if calls_alone[partner] > externalCapacity[partner]
        end#for

            remaining_calls_to_distribute = calls_to_distribute.clone
            while (remaining_calls_to_distribute.sum >= 1 && externalCapacity.sum >= 1)
     
              int    = suche_naechstes_interval(remaining_calls_to_distribute,oeffnungszeiten)
              calls  = remaining_calls_to_distribute[int]
              anteil = berechne_anteil_pro_partner(externalCapacity,forecast,remaining_calls_to_distribute)    

              calls_remaining = calls
              remaining_calls_to_distribute[int] = 0
              partner_done = Array.new(@displayedActs,0)
              for partner in (0 ... @displayedActs) # Set done if not open
                partner_done[partner] = 1 unless open_at_interval(oeffnungszeiten[partner],int) 
              end#for

              while partner_done.sum < @displayedActs  #Solange noch ein Partner da
                partner = select_next_partner_to_forecast(partner_done,externalCapacity)

                calls_per_partner = calls * anteil_offen(anteil,partner,int,oeffnungszeiten)
                calls_per_partner = calls_remaining if (calls_remaining < calls_per_partner) || (calls_remaining > calls_per_partner && (@displayedActs-partner_done.sum)==1)

                if calls_per_partner <= externalCapacity[partner]
                    forecast[partner][int]     = calls_per_partner
                    externalCapacity[partner] -= calls_per_partner
                    calls_remaining           -= calls_per_partner
                else
                    forecast[partner][int]     = externalCapacity[partner]
                    calls_remaining           -= externalCapacity[partner]
                    externalCapacity[partner]  = 0
                end

                partner_done[partner] = 1
                
              end#while partner_done              
            end#while
            
         end# if fuer_extern
          
          
          fs << html_table(forecast,forecastcurveData.to_a ,internalcurveData.to_a ,calls_to_distribute,oeffnungszeiten )
          puts fs

          write_calculated_curve_data(externalcurveData,forecast)
          
      end#each date
        
    end#def runCalculation 
  

    def select_next_partner_to_forecast(partner_done,externalCapacity)
		partner = 0
		while partner_done[partner]==1 && partner < partner_done.size # Search first partner which is not done
		  partner += 1
		end 
		for i in (0 ... partner_done.size) # Now find partner with lowest capacity
		  partner = i if partner_done[i] == 0 && externalCapacity[partner]>=externalCapacity[i]
		end #for
        return partner
	end
				
  
    def write_calculated_curve_data(externalcurveData,forecast)
      for i in (0 ... @displayedActs)
        externalcurveData[i].version   = VERSION_FORECAST
        externalcurveData[i].read(0) or raise "Konnte Queue nicht lesen"
        forecast[i].each_index {|ind| externalcurveData[i][ind] = forecast[i][ind] * 100.0 }
        externalcurveData[i].write!
      end#for  
    end #def write...
    
    
    def suche_naechstes_interval(remaining_calls_to_distribute,oeffnungszeiten)
      remaining_calls = remaining_calls_to_distribute.clone
      remaining_calls.each_index do |i|
        return i if remaining_calls[i]>0 && count_partners_open(oeffnungszeiten,i)==1
		factor=0
        for partner in (0 ... @displayedActs) # Set done if not open
          factor += 1 unless open_at_interval(oeffnungszeiten[partner],i) 
        end#for
        remaining_calls[i] = remaining_calls[i].to_f * (factor+1)**5
      end
      return remaining_calls.max_interval   # suche interval mit größter restmenge      

    end 
    
    
    # Zähle calls, die intern gehandelt werden, aber zähle nicht negative wenn mehr interne kapazität als forecast da ist
    def intern_gehandelte_calls(forecast,internal)
      sum = 0.0
      forecast.each_index do |i|
        sum += (forecast[i] > internal[i]) ? internal[i] : forecast[i]
      end
      return sum
    end
    
    #Gibt den anteil zurück bezogen auf die anzah lder partner die offen haben (also wenn ur 2 partner offen haben von 3 und jeder hat 1/3, dann sollte 1/2 zurückgegeben werden)   
    def anteil_offen(anteil,partner,interval,oeffnungszeiten)
      return 0.0 unless open_at_interval(oeffnungszeiten[partner],interval)
      gesamt = 0.0
      for p in (0 ... @displayedActs)
         gesamt += anteil[p] if open_at_interval(oeffnungszeiten[p],interval)
      end
      anteil[partner]/gesamt
    end 

    def open_at_interval(h,i)
      return false unless h
	  from = h[0]/30
      to = h[1] == 0 ? 48 : h[1]/30
      return (from<=i && to > i)
    end 

    
    #how many partners have open on this slot
    def count_partners_open(oeffnungszeiten,interval)
      count = 0
      oeffnungszeiten.each do |op|
        count +=1 if open_at_interval(op,interval) # op[0]/30<=interval && (op[1]/30 > interval || op[1]==0)
      end
      return count
    end
    
    def opening_times(curverep,curve, date)
	  eventid = curverep.calendar(curve.id, date, date).first.eventType.id
	  return nil unless curve.eventTypes().include?(eventid)
	  return ([curve.eventBegin(eventid),curve.eventEnd(eventid)])
    end#def opening_times

    def opening_time_interval_count(h) #h =[from, to] in minutes
      from = h[0]/30
      to = h[1] == 0 ? 48 : h[1]/30
      return(48 - from - (48-to))
    end#def opening_times

    def berechne_anteil_pro_partner(externalCapacity,forecast,remaining_calls_to_distribute)    
	  anteil = Array.new(@displayedActs,0)
      remaining_capa = remaining_calls_to_distribute.sum.to_f # What is the capa in all intervals where there is not only one partner
        for partner in (0 ... @displayedActs)
		  anteil[partner] = (remaining_capa > 0.0) ? externalCapacity[partner]  / remaining_capa : 0.0
        end#for

        return anteil 
    end
 
    
  def tcell(content, css=nil)
    td = BlockTag.new("td")
    td << content
    td.style=css if css 
	td
  end
  
  def html_table(forecast,generalforecast,internal,distribute,oeffnungszeiten)
        @curves_hash = Hash.new
        @curves.each {|c| @curves_hash[c.id] = c }
        
         


          table = BlockTag.new("table") 
          table.border=1
            tr = BlockTag.new("tr")
            tr << tcell("Intervall","background-color:#99ccff;")
            tr << tcell("Öffn.","background-color:#99ccff;")
            forecast.first.each_index do |h|
              tr << tcell(secondsToTimeString(h*1800),"background-color:#99ccff;")
            end         
            tr << tcell("Summe","background-color:#99ccff;")
            table << tr

            tr = BlockTag.new("tr")
            tr << tcell("Gesamtforecast","background-color:#99ccff;")
            tr << tcell("","background-color:#99ccff;")
            generalforecast.each do |h|
              tr << tcell((h / 100.0).to_s.gsub(/\./,','))
            end         
            tr << (BlockTag.new("td") << (generalforecast.sum / 100.0).to_s.gsub(/\./,','))
            table << tr

            tr = BlockTag.new("tr")
            tr << tcell("Intern","background-color:#99ccff;")
            tr << tcell("","background-color:#99ccff;")
            internal.each do |h|
              tr << tcell((h / 100.0).to_s.gsub(/\./,','))
            end         
            tr << (BlockTag.new("td") << (internal.sum / 100.0).to_s.gsub(/\./,','))
            table << tr

            tr = BlockTag.new("tr")
            tr << tcell("GesamtExtern","background-color:#99ccff;")
            tr << tcell("","background-color:#99ccff;")
            distribute.each do |h|
              tr << tcell(round(h,1).to_s.gsub(/\./,','))
            end         
            tr << tcell((round(distribute.sum,1)).to_s.gsub(/\./,','))
            table << tr



            forecast.each_index do |row|
            tr = BlockTag.new("tr")
              tr << tcell(@curves_hash[args['tarqueue'   + row.to_s].to_i].name,"background-color:#99ccff;")
			  o= oeffnungszeiten[row]
              tr << tcell((o ? "#{secondsToTimeString(o[0]*60)}-#{secondsToTimeString(o[1]*60)}" : "closed"),"background-color:#99ccff;")
            forecast[row].each_index do |i|
              tr << tcell((forecast[row][i] ? round(forecast[row][i],1) : "-").to_s.gsub(/\./,','),open_at_interval(o,i) ? nil : "background-color:#f5f5f5;")
            end         
            tr << tcell((round(forecast[row].sum,1)).to_s.gsub(/\./,','))
            table << tr
          end
          table
  end  
        
        # curveDataCalls           = ISPS::CurveData.new(@repCurve)
        # curveDataCalls.curve     = curve
        # curveDataCalls.valueType = valueTypeCalls
        # curveDataCalls.version   = version
        # curveDataCalls.date      = @dateStart

        # curveDataAht             = ISPS::CurveData.new(@repCurve)
        # curveDataAht.curve       = curve
        # curveDataAht.version     = version

        # twRep                    = session.repOf(ISPS::PlanRep)
        # workContext              = ISPS::PlanContext.new(twRep)
        # workContext.dateFrom     = @dateStart
        # workContext.dateTo       = @dateStart + (@numDays - 1)
        # workContext.version      = ISPS::PlanContext::VERSION_WORK
        # workContext.displayLevel = ISPS::PlanContext::DISPLAY_MINIMAL
        # workContext.defLayerMode = ISPS::PlanContext::LAYER_MODE_TOP
        # workContext.level        = [ISPS::PlanContext::LEVEL_PLAN]
        # workContext.write!

        # #Get planUnits and openings
        # planUnit    = Array.new()
        # openings    = Array.new()
        # task        = Array.new()
        # reqPerDate  = Array.new()
        # planUnitCal = Array.new()
        
        # for nPU in 0...@displayedActs
          # planUnit[nPU] = session.puFor(args['planunitid' + nPU.to_s].to_i) # Several PUs
          # task[nPU]     = session.taskTypeFor(args['activity'  + nPU.to_s].to_i)
          # openings[nPU] = planUnit[nPU].openings(@dateStart, @dateStart + @numDays)
          
          # # Check if all PU/Activity combinations are different
          # for i in (0 ... nPU)
            # if (planUnit[nPU].id == planUnit[i].id) and (task[nPU].id == task[i].id)
              # raise tr(PU_ACTIVITY_NOT_UNIQUE_ERROR_TEXT) + "(#{nPU+1}=#{i+1})"
            # end#if
          # end#for
          
          # #Check if all PUs have same time raster
          # if (planUnit[nPU].raster != planUnit[PRIMARY_PU].raster)
            # raise tr(PU_TIME_RASTER_DIFFER_ERROR_TEXT)
          # end#if
          
          # reqPerDate[nPU]= ISPS::TaskRequirement.new2(
               # twRep,
               # ISPS::PlanContext::VERSION_WORK,
               # ISPS::PlanContext::LEVEL_PLAN,
               # planUnit[nPU].id)
               
          # planUnitCal[nPU] = ISPS::PlanUnitCalendar.new(twRep)
          # planUnitCal[nPU].read(
              # ISPS::PlanContext::VERSION_WORK,
              # ISPS::PlanContext::LEVEL_PLAN,
              # planUnit[nPU].id,
              # @dateStart,
              # @dateStart + @numDays)

        # end#for
        
        # t = BlockTag.new('table',{:style=>'font-size: 10pt;',:border=>"0", :cellspacing=>"0", :cellpadding=>"3"})

        # dataRows = []
        
        # styleLeft  = {"style" =>"text-align:left;, width: 200px"}
     
        # #for each PU
        # for nPU in 0...@displayedActs
            
            # newTdWithText(ADD_TEXT_S, nil, false, false, STYLE_RIGHT200PX)
            
            # dataRows[0] << newTdWithText(planUnit[nPU].name, nil, false, false, styleLeft)
            # dataRows[1] << newTdWithText(task[nPU].name,     nil, false, false, styleLeft)
            # dataRows[2] << newTdWithText((@fixAHT[nPU]/100).to_s,     nil, false, false, styleLeft) if (@idValueTypeAHT <= 0)
            
            # if (PRIMARY_PU == nPU)  # Only Min/Max staff for first PU
                # dataRows[3] << newTdWithText((@minStaff / 100.0).to_s ,nil, false, false, styleLeft)
                # dataRows[4] << newTdWithText((@maxStaff / 100.0).to_s ,nil, false, false, styleLeft) if (@maxStaff >= 0) 
            # end#if 
            
            # dataRows[5] << newTdWithText( "#{@servicePercentage[nPU]} / #{@serviceLevel[nPU]}", nil, false, false, styleLeft)
            # dataRows[6] << newTdWithText( @serviceAdd[nPU].to_s, "%", false, false, styleLeft)
            
            # @serviceAdd[nPU]= 1 + (@serviceAdd[nPU] / 100.0)
        # end#for
        
        # #######################################
        # #show selected planning unit parameters
        # fs  = fieldset(bold(tr(PLANUNIT_PARAM_TEXT)))
        
        # dataRows.each{ |dataArr|
            # tr = BlockTag.new("tr")                               #new data row
            # dataArr.each{ |tbData| tr << tbData} if dataArr   #fill colums
            # t << tr
        
        # @percentageSet ? fs = fieldset(bold(tr(PERCENTAGE_TEXT))) : fs = fieldset(bold(tr(MAXCALLS_TEXT))) 
       
        # t = BlockTag.new('table', {:style=>'font-size: 10pt;', :border=>"0", :cellspacing=>"0", :cellpadding=>"3"})
        # detailsTable.each{ |rowArr|
        
                # 3.upto(rowArr.size-1){ |index| 
                    # tableRow <<  newTdWithText(rowArr[index], nil, false, false, {:style=>'text-align: left; width: 200'})
                # }
        # eventIds = curve.eventTypes(false)
  
        
        # # Start of loop over days
        # workContext.dateFrom.upto(workContext.dateTo){|date|
        
            # puts fs if (fs != nil)
            # fs = nil
            # curveDataCalls.date= date
            
            # fs = fieldset(bold(date.to_s))
            
            # #Again for each PU
            # puOpening = Array.new()
            # for nPU in 0...@displayedActs
                # if (@weekdaymode == true)
                  # #Get daytype
                  # dayType = planUnitCal[nPU].dayType(date)
                # else 
                  # dayType = ((date - @dateStart) % @displayDays) + 1
                # end  
                # puOpening[nPU]= openings[nPU].find{|o| o.dayTypeId == dayType}
                
                # if  ((!puOpening[nPU]) && @chkPuOpening)
                    # fs << (text(tr(NOOPENINGHOUR_TEXT) + planUnit[nPU].name))
                    # next
                # end
            # end#for

            # unless curveDataCalls.read(0)
                
                # transText = (tr(CALL_DATA_ERROR_TEXT))
                # textPart2 = "(%s / %s): " % [ curveDataCalls.curve.name, curveDataCalls.valueType.name]
                # fs << ( text(transText + textPart2))
                # fs << "#{curveDataCalls.errorInfo.join(' ')}"
                # next
            # end

            # unless ( eventIds.include? (curveDataCalls.eventTypeId) )     
                # fs <<  (text(tr(NO_QUEUE_OPENING_TEXT)))
                # next
            # end

            # if valueTypeAht.valid?
                # curveDataAht.date= date
                # curveDataAht.valueType= valueTypeAht  
                # unless curveDataAht.read(0)
                    # fs << (text(tr(AHT_DATA_ERROR_TEXT) + ": #{curveDataAht.errorInfo.join(' ')}"))
                    # next
                # end
            # end

            # openTime  = Array.new()
            # closeTime = Array.new()
                
            # #Again for each PU
            # for nPU in (0 ... @displayedActs)
                # unless reqPerDate[nPU].read(date, task[nPU].id)
                    # fs <<  (text(tr(REQ_ERROR_TEXT) + ": #{reqPerDate[nPU].errorInfo.join(' ')}"))
                    # next
                # end
                # openTime[nPU]  = puOpening[nPU] ? puOpening[nPU].openTime : 0
                # closeTime[nPU] = puOpening[nPU] ?((puOpening[nPU].closeTime == 0) ? ADAY_IN_SECONDS : puOpening[nPU].closeTime) : 0
                
                # # curve time in minutes whereas planning unit times in seconds
                # if curveDataCalls.openTime * 60  > openTime[nPU]
                    # openTime[nPU] = curveDataCalls.openTime * 60
                # end
                # if curveDataCalls.closeTime != 0 && curveDataCalls.closeTime * 60 < closeTime[nPU]
                    # closeTime[nPU] = curveDataCalls.closeTime * 60
                # end
             # end
                
             # t = table

             # ahtValue = Array.new()

             # #Get whole value data before iterating through PUs
             # values = Array.new()
             # for i in 0...(ADAY_IN_SECONDS / planUnit[PRIMARY_PU].raster) # Always use raster of master pu
                 # values[i] = getValueAtIdx(i,curveDataCalls, reqPerDate[PRIMARY_PU].timeRaster)
             # end#for
            
                
             # #Again for each PU   
             # for nPU in (0 ... @displayedActs)   
               
                # #Get dayType if needed (mon,tue,wed,...)
                # if (@weekdaymode == true)
                  # #Get daytype
                  # currWeekDay = planUnitCal[nPU].dayType(date)
                # else 
                  # currWeekDay = ((date - @dateStart) % @displayDays) + 1
                # end  
                # ahtValue[nPU]  = @fixAHT[nPU]

                # lstIdx = (ADAY_IN_SECONDS / planUnit[nPU].raster) - 1
                
                # for i in (0 .. lstIdx)            
                    # astep= planUnit[nPU].raster * i
                    
                    # tdTime  = BlockTagNewTd(STYLE_RIGHT200PX)
                    # tdPU    = BlockTagNewTd(STYLE_RIGHT200PX)
                    # tdAht   = BlockTagNewTd(STYLE_RIGHT200PX)
                    # tdCalls = BlockTagNewTd(STYLE_RIGHT200PX)
                    # tdReq   = BlockTagNewTd(STYLE_RIGHT200PX)
     
                    # # Only write time on top of first PU
                    # tdTime << ((PRIMARY_PU == nPU) ? secondsToTimeString(astep) : nil)


                    # ahtValue[nPU] = getValueAtIdx(i,curveDataAht, reqPerDate[nPU].timeRaster) if valueTypeAht.valid?

                    # value   = values[i]
                    # percent = 0

                    # if (@chkPuOpening && ((astep < openTime[nPU]) || (astep >= closeTime[nPU])))
                        # reqPerDate[nPU][i] = 0
                    # else
                      
                      # # Get timeslot row or -1 if not timeslot for given time
                      # tsRow = timeslotRowForTime(@timeslotStart, @timeslotEnd, currWeekDay-1, @displayRowsPerDay, astep) 
                      
                      # if (tsRow < 0) #not found
                        # value = 0 
                        # erl   = 0
                      # else  

                          # # If percentage set, then divide value now per percent, else check max values
                          # if (USE_PERCENTAGE == @percentageSet) 

                               # percent = @percentage[nPU][currWeekDay-1][tsRow]
                               # value = (value * percent / 100) 

                          # else #max calls set
                              
                              # #check if too many calls and hand over to next PU
                              # maxcallsforwholeslot = (@percentage[nPU][currWeekDay-1][tsRow]) * 100
    
                              # traster = ((@timeslotEnd[currWeekDay-1][tsRow]- @timeslotStart[currWeekDay-1][tsRow]) / (planUnit[nPU].raster))
                              # maxcalls = maxcallsforwholeslot / traster
    
                              # if (maxcalls >= 0) and (values[i] > maxcalls) #Only divide if set and larger max
                                
                                # value      = maxcalls    # Handle only possible call volume 
                                # values[i] -= maxcalls    # Remaining calls for next PU
                                
                                # if ((nPU == (@displayedActs - 1)) and (values[i] > 0)) # Last PU and remaining rest
                                    
                                    # spanWarningMsg << displayWarning(warningMsgCount, date, astep)
                                    # warningMsgCount += 1
                                    
                                    # # After showing warning last PU will get all stuff in any case
                                    # value       += values[i]
                                    # values[i]    = 0

                                # end#if
                              # else
                                # value     = values[i]    # Handle all calls in this PU
                                # values[i] = 0            # No more calls for other PUs
                              # end#if
                          # end#if percentageSet                    
                      
                          # erl =  Erlang::agentCountSl(
                              # ahtValue[nPU] / 100.0 ,
                              # value / 100.0,
                              # @serviceLevel[nPU],
                              # @servicePercentage[nPU],
                              # planUnit[nPU].raster / 60)
                      # end    
                      
                      # reqPerDate[nPU][i]= (erl ? (erl * 100 * @serviceAdd[nPU]) : 0)
                      
                      # # Check if min/max reached
                      # if (PRIMARY_PU == nPU)                                       # min/max only for first PU
                          
                          # if ((reqPerDate[nPU][i] > @maxStaff)  && (@maxStaff >= 0))
                            
                            # # Calculate value not be handled by maxStaff
                            # newValue = calculateValueForMaxStaff(@maxStaff, value, ahtValue[nPU] / 100.0, 
                                                            # @serviceLevel[nPU], @servicePercentage[nPU], 
                                                            # planUnit[nPU].raster / 60, @serviceAdd[nPU])

                            # restValue = value - newValue
                            # value= newValue                                       # Set to display correct figure in table
                            # reqPerDate[nPU][i]= @maxStaff                         # Only use maxStaff-number of people
                            
                            # # Handover this rest to other PUs 
                            # if USE_PERCENTAGE==@percentageSet                     # For Percentage calculate value for other units

                              # if (percent == 100)                                 # No handover to other PUs if 100 percent
                                
                                 # spanWarningMsg << displayWarning(warningMsgCount,date,astep)
                                 # warningMsgCount += 1

                              # else
                                # values[i] = (restValue / ((100 - percent) / 100.0)) 
                              # end#if 100% 

                            # else                                                  # For maxCalls simply give all to other unit

                              # values[i] += restValue
                            # end#if %used                       
 
                          # elsif (reqPerDate[nPU][i] < @minStaff) 
                            # reqPerDate[nPU][i]= @minStaff
                          # end#if max/min
                      # end#if primary pu   
                    
                    # end#if astep

                    # #Write cellsvto output now
                    # tdPU    << nil
                    # tdCalls << "#{(value/ 100.0 )}"
                    # tdAht   << "#{(ahtValue[nPU]/ 100.0 )}" 
                    # tdReq   << "#{(reqPerDate[nPU][i]/ 100.0 )}"
                    
                    # trTime  << tdTime
                    # trPU    << tdPU
                    # trCalls << tdCalls
                    # trAht   << tdAht
                    # trReq   << tdReq

                # end#for lstIdx
        
              # # Write whole rows to table
               # t << trTime << trPU << trCalls << trAht << trReq   
             
              # if (@chkWrDataAfterCalc == true)
                  # unless (reqPerDate[nPU].write) 
                      # fs <<  (text(tr(REQ_NOT_WRITTEN_TEXT) + " #{reqPerDate[nPU].errorInfo.join(' ')}"))
                  # end#unless
              # end#if

              # # Write data to queue is checkbox set
              # writeDailyRequirementToQueue(nPU, reqPerDate[nPU], date, fs)          
               
           # end#for Pus   
           # fs << t
           # # Show table in fieldset with given date
           # if (date <= workContext.dateTo)
               # puts fs        
               # fs = nil
           # end
        # }
        
 

    ##########################################################################################
    #
    def getValueAtIdx(index, curveData, taskReqRaster)
     
        if curveData.raster * 60 == taskReqRaster
            return curveData[index]
        elsif curveData.raster * 60 < taskReqRaster
           result   = 0
           count    = 0
           ratio    = taskReqRaster / (curveData.raster * 60)
           intIndex = index * ratio
           
           for i in intIndex ... (intIndex + ratio) 
              
              result += curveData[i]
              count = count + 1 unless curveData[i] != 0

           end#for

           result /= ratio if curveData.aggregation == ISPS::CurveValueType::AGG_AVERAGETOTAL
          
           if curveData.aggregation == ISPS::CurveValueType::AGG_AVERAGE
                  result /= (ratio - count) unless count == ratio
           end

           return result

        elsif curveData.raster * 60 > taskReqRaster

           ratio = curveData.raster * 60 / taskReqRaster
           result = curveData[(index - (index % ratio) )/ ratio]

           if (curveData.aggregation == ISPS::CurveValueType::AGG_SUM)
              result /= ratio
           end#if

           return result
        end#if
    end#def getValueAtIdx
   
    ##########################################################################################
    # For given seconds return time string HH:MM
    #
    def secondsToTimeString(aSecondsValue) # Time as integer in seconds
    
        hour = aSecondsValue / HOUR_IN_SECONDS
        min  = (aSecondsValue % HOUR_IN_SECONDS) / MINUTE_IN_SECONDS
        return "#{(hour / 10)}#{(hour % 10)}:#{(min / 10)}#{(min % 10)}"
    end#def secondsToTimeString  
 
    ##########################################################################################
    #Gets TimeValue in format "HH:MM" and returns time in seconds
    #
    def timeStringToSeconds(timeValue)  # time as string in format "HH:MM"
    
        hour,min=0
        begin 
          hour = timeValue[0,2].to_i
          min = timeValue[3,2].to_i
        rescue
            raise(tr(NO_VALID_TIME_ERROR_TEXT) + " (#{timeValue})")
        end  
 
        if (min < 0) or (min > 59) or (hour < 0) or (hour > 23) 
            raise(tr(NO_VALID_TIME_ERROR_TEXT) + " (#{timeValue})")
        end
          
        return (hour * HOUR_IN_SECONDS + min * MINUTE_IN_SECONDS)
    end#def timeStringToSeconds       
      
    ##########################################################################################
    # Returns the row of the timeslot for a given time
    #
    def timeslotRowForTime(tsdataStart, # Array of starting times 
                           tsDataEnd,   # Array of end times
                           weekday,     # current weekday
                           rowsPerDay,  # How many rows are there for each day
                           timeinsec)   # Time to get timeslot for
                           
        for i in 0...rowsPerDay 
          if (tsdataStart[weekday]) and (tsdataStart[weekday][i]) and (tsDataEnd[weekday]) and (tsDataEnd[weekday][i])
            if (tsdataStart[weekday][i] <= timeinsec) and (tsDataEnd[weekday][i] >= timeinsec)
              return i
            end#if
          else
            return -1
          end#if
        end#for
 
      return -1
    end#def timeslotValue  
      
    ##########################################################################################
    # Check if value is <0 (field empty, then get "remaining" value) else return value
    #   (Must not be called when using max calls instead of percentage for calculation)
    #
    def getPercentage(percent,    # Array withh percentage/maxcall values
                      nPU,        # number of PU to get value for
                      pucount,    # Count of planning units
                      curWDay,    # weekday to get data for
                      tsRow)      # row for current timeslot
                      
        if ((percent[nPU][curWDay][tsRow]) >= 0)
        
            return (percent[nPU][curWDay][tsRow])
        else # No value set, so calculate from others
          
            allPercent = 0
            allEmpty   = 0
            
            for i in 0...pucount
                if percent[i][curWDay][tsRow]>=0
                    allPercent += percent[i][curWDay][tsRow]
                else#empty
                    allEmpty += 1
                end#if
            end#for
            
            percent[nPU][curWDay][tsRow] = (100-allPercent) / allEmpty unless allEmpty==0 
            return percent[nPU][curWDay][tsRow]
        end#if  
    end#def getPercentage
    
    ##########################################################################################
    # How much value can the maxstaff handle?
    #   (like doing the inverse erlang formula)
    #
    def calculateValueForMaxStaff(maxStaff,            # maximum staff
                                  oldValue,            # old value which was too high
                                  aht,                 # ErlangC parameter
                                  serviceLevel,        # ErlangC parameter
                                  servicePercentage,   # ErlangC parameter
                                  raster,              # ErlangC parameter
                                  serviceAdd)          # Percentage to add to value
        
        return 0  if (maxStaff == 0)  # 0 people can only handle 0 value
                         
        erl = maxStaff + 1
        newValue = oldValue
        
        while (erl - maxStaff) > 0.1 

           # As the erlang formula is not linear but steps we can use larger steps as well
           newValue -= 100   
           erl = Erlang::agentCountSl(
                        aht ,
                        newValue / 100.0,
                        serviceLevel,
                        servicePercentage,
                        raster)
           erl  = (erl ? erl * 100 * serviceAdd : 0)
        end#while
        return newValue
    end#def
    
    ##########################################################################################
    # Display warning message
    def displayWarning(warningMsgCount, date, time)
    
        if (warningMsgCount<10)
            return bold(date.to_s + " " + secondsToTimeString(time) + " " +
                         tr(NOT_ALL_CALLS_WARNING_TEXT)) << BlockTag.new("br")
        else
            return nil                 
        end#if                       
    end#def displayWarning
      
    ##########################################################################################
    # Display input field
    def inpRight(name, default= nil, width = 50)
    
         i = inp(name,default)
         i.style = "width: #{width}px; text-align: right;"
         i
    end  
    
    # Write daily requirement
    def writeDailyRequirementToQueue(nPU,    # Number of PU queue to be stored
                                     req,    # data
                                     date,
                                     outputFieldset)   # storage date

        writeCurveString = 'writecurve' + nPU.to_s
        queueString      = 'tarqueue'   + nPU.to_s
        valTypeString    = 'tarvaltype' + nPU.to_s
        versionString    = 'tarversion' + nPU.to_s
     
        isChecked    = (args[writeCurveString] == "1")
        idTarQueue   = (args[queueString]|| 0).to_i
        idTarVt      = (args[valTypeString]|| 0).to_i
        idTarVersion = (args[versionString]|| 0).to_i

        if (isChecked && (idTarQueue != 0) && (idTarVt != 0) && (idTarVersion != 0) && req)       

            curve = @curves.find{|o| o.id == idTarQueue}

            curveData           = ISPS::CurveData.new(@repCurve)
            curveData.curve     = curve
            curveData.valueType = idTarVt
            curveData.version   = idTarVersion
            curveData.date      = date

            if req.timeRaster >= (curve.raster * 60)
                ratio = req.timeRaster / (curve.raster * 60)
                for idx in 0 ... req.size
                    for i in 0...ratio
                        curveData[(idx * ratio) + i] = req[idx]
                    end
                end
            else
                ratio = (curve.raster * 60)/ req.timeRaster
                for idx in 0 ...(req.size / ratio)
                    average = 0.0
                    for i in 0...ratio
                        average  += req[(ratio * idx) + i]
                    end
                    average /= ratio
                    curveData[idx] = average
                end
            end
            
            if !curveData.write()
                 valueType = @vtTypes.find{|o| o.id == idTarVt}
                 version = @versions.find{|o| o.id == idTarVersion}
                 outputFieldset <<  (text bold(tr(TARGET_QUEUE_DATA_ERROR_TEXT) + curve.name + ", " + valueType.name + ", " + version.name ))
                 outputFieldset << (text bold(curveData.errorInfo.join(' ')) )
            else         
                valueType = @vtTypes.find{|o| o.id == idTarVt}
                version = @versions.find{|o| o.id == idTarVersion}
                outputFieldset  << (text tr(TARGET_QUEUE_DATA_WRITE_TEXT) + curve.name + ", " + valueType.name + ", " + version.name)
            end
        end
     end
     
    def logOutput(msg, asError)
        if (asError == true)
            puts text bold msg
        else
            puts text msg
        end
   end

  def getWeekday(i)

      if (@weekdaymode == true)
          return [tr(MONDAY_TEXT), tr(TUESDAY_TEXT),tr(WEDNESDAY_TEXT), tr(THURSDAY_TEXT), tr(FRIDAY_TEXT), tr(SATURDAY_TEXT), tr(SUNDAY_TEXT)].at(i)
      else
          return tr(DAY_TEXT) + ' '+ (i + 1).to_s
      end#if
  end#def getWeekday

  def round(val,i)
    return val.to_i if i == 0
    (val*10**i).round / 10.0**i
  end


  
  
  
end





################################################################################
#
#  Class Name:-         Date
#  Class Description:-  Used to handle the date functionality.
#
################################################################################
class Date
    
    ############################################################################
    #
    #   Method Name:-   to_s
    #   Description:-   Convert a date to String.
    #   Parameters:-    None.
    #   Return Values:- String containing a localised Date.
    #
    ############################################################################
    def to_s
        case $ISPSLanguage
            when German, Norwegian  #German, Norwegian
                format('%02d.%02d.%04d', self.day, self.month, self.year)
            when English_US 
                format('%02d/%02d/%04d', self.month, self.day, self.year)
            when Dutch 
                format('%02d-%02d-%04d', self.day, self.month, self.year)
            when Swedish
                format('%04d-%02d-%02d', self.year, self.month , self.day)
            else # French, Italian, English (UK), Spanish, Portuguese
                format('%02d/%02d/%04d', self.day, self.month, self.year)
        end
    end #to_s
    
end #class Date

################################################################################
#
#  Module Name:-        Localize
#  Module Description:- Generic Localisation Module for script.
#
################################################################################
module Localize
  WEEKDAYS = ["So","Mo","Di","Mi","Do","Fr","Sa"]



    THIS_SCRIPT_NAME        = { English_UK => 'iWFM Requirement Script (Distribute Workload between Multiple Planning Units)',
                                English_US => 'iWFM Requirement Script (Distribute Workload between Multiple Planning Units)',
                                German  => 'Vodafone - Verteilung auf Partner',
                                French  => 'Scénario des besoins iWFM (Répartir la charge de travail entre plusieurs unités opérationnelles).',
                                Swedish => 'iWFM Behovsskript (fördela arbetsbelastning över flera planeringsenheter)',
                                Italian =>'Script del fabbisogno (distribuisce il carico di lavoro tra unità pianificative multiple) iWFM.',
                                Dutch => 'iWFM-behoeftescript (distributie van werklast tussen meerdere eenheden)',
                                Spanish => 'Script de necesidad de iWFM (Distribuir la carga de trabajo entre varias unidades de planificación)',
                                Norwegian => 'iWFM behovsskript (fordel arbeidsmengde på flere planleggingsenheter)',
                                Portuguese => 'Script de falta iWFM (Distribuir a carga de trabalho entre várias unidades de planificação)'}

    
    PLANUNIT_PARAM_TEXT     = { English_UK => 'Planning unit parameters',
                                English_US  => 'Planning unit parameters',
                                German  => 'Planungseinheiten-Parameter',
                                French  => 'Paramètres d\’unité opérationnelle',
                                Swedish => 'Planeringsenhetens parametrar',
                                Italian => 'Parametri Unità pianificative',
                                Dutch => 'Eenheidsparameters',
                                Spanish => 'Parámetros de la unidad de planificación',
                                Norwegian => 'Planleggingsenhetens parametre',
                                Portuguese => 'Parâmetro Unidade de planificação'}

    PU_TEXT                 = { English_UK => 'Planning unit',
                                English_US  => 'Planning unit',
                                German  => 'Planungseinheit',
                                French  => 'Unité opérationnelle',
                                Swedish => 'Planeringsenhet',
                                Italian => 'Unità pianificativa',
                                Dutch => 'Eenheid',
                                Spanish => 'Unidad de planificación',
                                Norwegian => 'Planleggingsenhet',
                                Portuguese => 'Unidade de planificação'}

    ACT_TEXT                = { English_UK => 'Activity',
                                English_US  => 'Activity',
                                German  => 'Aktivität',
                                French  => 'Activité',
                                Swedish => 'Aktivitet',
                                Italian => 'Attività',
                                Dutch => 'Activiteit',
                                Spanish => 'Actividad',
                                Norwegian => 'Aktivitet',
                                Portuguese => 'Actividade'}

    DATE_TEXT               = { English_UK => 'Time period and options',
                                English_US  => 'Time period and options',
                                German  => 'Zeitraum und Optionen',
                                French  => 'Périodes et options',
                                Swedish => 'Arbetstider och alternativ',
                                Italian => 'Periodo e opzioni',
                                Dutch => 'Periode en opties',
                                Spanish => 'Período y opciones',
                                Norwegian => 'Tidsperiode og alternativer',
                                Portuguese => 'Período de tempo e opções'}

    DATE2_TEXT              = { English_UK => 'Date',
                                English_US  => 'Date',
                                German  => 'Datum',
                                French  => 'Date',
                                Swedish => 'Datum',
                                Italian => 'Data',
                                Dutch => 'Datum',
                                Spanish => 'Fecha',
                                Norwegian => 'Dato',
                                Portuguese => 'Data'}
                                
    OPTIONS_TEXT            = { English_UK => 'Options',
                                English_US  => 'Options',
                                German  => 'Optionen',
                                French  => 'Options',
                                Swedish => 'Alternativ',
                                Italian => 'Opzioni',
                                Dutch => 'Opties',
                                Spanish => 'Opciones',
                                Norwegian => 'Alternativer',
                                Portuguese => 'Opções'}                                                      

    START_DATE_TEXT         = { English_UK => 'Start date',
                                English_US  => 'Start date',
                                German  => 'Startdatum',
                                French  => 'Date de début',
                                Swedish => 'Startdatum',
                                Italian => 'Data d\'inizio',
                                Dutch => 'Startdatum',
                                Spanish => 'Fecha de inicio',
                                Norwegian => 'Startdato',
                                Portuguese => 'Data de início'}
                                
   INVALID_START_DATE   = {     English_UK => 'Start date is invalid.',
                                English_US  => 'Start date is invalid.',
                                German  => 'Das Startdatum ist ungültig.',
                                French  => 'La date de début n\'est pas valable.',
                                Swedish => 'Startdatumet är ogiltigt.',
                                Italian => 'La data d\'inizio non è valida.',
                                Dutch => 'Startdatum is ongeldig.',
                                Spanish => 'La fecha de inicio no es válida.',
                                Norwegian => 'Startdatoen er ugyldig.',
                                Portuguese => 'Data de início inválida.'}

    NUM_OF_DAYS_TEXT        = { English_UK => 'Number of days',
                                English_US  => 'Number of days',
                                German  => 'Anzahl Tage',
                                French  => 'Nombre de jours',
                                Swedish => 'Antal dagar',
                                Italian => 'Numero di giorni',
                                Dutch => 'Aantal dagen',
                                Spanish => 'Número de días',
                                Norwegian => 'Antall dager',
                                Portuguese => 'Número de dias'}

    CALC_RESULT_TEXT        = { English_UK => 'Calculation result',
                                English_US  => 'Calculation result',
                                German  => 'Berechnungsergebnis',
                                French  => 'Résultat du calcul',
                                Swedish => 'Beräkningsresultat',
                                Italian => 'Risultato del calcolo',
                                Dutch => 'Uitkomst',
                                Spanish => 'Resultado del cálculo',
                                Norwegian => 'Beregningsresultat',
                                Portuguese => 'Resultado do cálculo'}

    PERCENTAGE_TEXT         = { English_UK => 'Percentage',
                                English_US  => 'Percentage',
                                German  => 'Prozentual',
                                French  => 'Pourcentage',
                                Swedish => 'Procent',
                                Italian => 'Percentuale',
                                Dutch => 'Percentage',
                                Spanish => 'Porcentaje',
                                Norwegian => 'Prosent',
                                Portuguese => 'Percentagem'}

    MAXCALLS_TEXT           = { English_UK => 'Max. calls',
                                English_US  => 'Max. calls',
                                German  => 'Max. Anrufe',
                                French  => 'Appels max',
                                Swedish => 'Max. antal samtal',
                                Italian => 'Chiamate max.',
                                Dutch => 'Max. aantal gesprekken',
                                Spanish => 'Máx. de llamadas',
                                Norwegian => 'Maks. samtaler',
                                Portuguese => 'Máx. de chamadas'}

    DAY_TEXT                = { English_UK => 'Day',
                                English_US  => 'Day',
                                German  => 'Tag',
                                French  => 'Jour',
                                Swedish => 'Dag',
                                Italian => 'Giorno',
                                Dutch => 'Dag',
                                Spanish => 'Día',
                                Norwegian => 'Dag',
                                Portuguese => 'Dia'}

    BEGIN_TEXT              = { English_UK => 'Start',
                                English_US  => 'Start',
                                German  => 'Beginn',
                                French  => 'Début',
                                Swedish => 'Start',
                                Italian => 'Inizio',
                                Dutch => 'Begin',
                                Spanish => 'Inicio',
                                Norwegian => 'Start',
                                Portuguese => 'Iniciar'}

    END_TEXT                = { English_UK => 'End',
                                English_US  => 'End',
                                German  => 'Ende',
                                French  => 'Fin',
                                Swedish => 'Slut',
                                Italian => 'Fine',
                                Dutch => 'Einde',
                                Spanish => 'Fin',
                                Norwegian => 'Slutt',
                                Portuguese => 'Terminar'}

    ADD_TO_REQ_TEXT         = { English_UK => 'Add to existing requirement',
                                English_US  => 'Add to existing requirement',
                                German  => 'Zu bestehendem Bedarf addieren',
                                French  => 'Ajouter au besoin existant',
                                Swedish => 'Addera till det sparade behovet',
                                Italian => 'Aggiungi al fabbisogno esistente',
                                Dutch => 'Optellen bij bestaande behoefte',
                                Spanish => 'Sumar a la necesidad existente',
                                Norwegian => 'Legg til lagret behov',
                                Portuguese => 'Adicionar à falta existente'}

    ADD_TO_ROW_TEXT         = { English_UK => 'Add up requirement of overlapping time-spans',
                                English_US  => 'Add up requirement of overlapping time-spans',
                                German  => 'Bedarf im Überschneidungsbereich addieren',
                                French  => 'Ajouter le besoin des périodes qui se chevauchent',
                                Swedish => 'Summera behovet för överlappande tidssegment',
                                Italian => 'Somma il fabbisogno delle fasce temporali sovrapposte',
                                Dutch => 'Behoefte in overlappingsgebied optellen',
                                Spanish => 'Sumar la necesidad de espacios que se solapan',
                                Norwegian => 'Legg til behov i overlappingsperioder',
                                Portuguese => 'Somar a falta de espaços de tempo sobrepostos'}

    INC_OPENING_HOUR_TEXT   = { English_UK => 'Observe planning unit\'s business hours',
                                English_US  => 'Observe planning unit\'s business hours',
                                German  => 'Öffnungszeiten der Planungseinheit beachten',
                                French  => 'Respecter les horaires d’ouverture de l’unité opérationnelle',
                                Swedish => 'Beakta planeringsenhetens öppettider',
                                Italian => 'Osserva orari di apertura dell\'unità pianificativa',
                                Dutch => 'Rekening houden met openingstijden van de eenheid',
                                Spanish => 'Tener en cuenta los horarios de apertura de la unidad de planificación',
                                Norwegian => 'Ta hensyn til planleggingsenhetens åpningstider',
                                Portuguese => 'Considerar horários de funcionamento da unidade de planificação'}

    WRITE_AFTER_CALCULATION = { English_UK => 'Write data after calculation?',
                                English_US  => 'Write data after calculation?',
                                German  => 'Daten nach Berechnung schreiben?',
                                French  => 'Écrire les données après le calcul ?',
                                Swedish => 'Skriva uppgifterna efter beräkning?',
                                Italian => 'Scrivi dati dopo il calcolo?',
                                Dutch => 'Gegevens schrijven na berekening?',
                                Spanish => '¿Escribir datos después del cálculo?',
                                Norwegian => 'Skrive data etter beregning?',
                                Portuguese => 'Escrever os dados após o cálculo?'}

    USE_PERCENTAGE_TEXT     = { English_UK => 'Use percentage values',
                                English_US  => 'Use percentage values',
                                German  => 'Prozentwerte verwenden',
                                French  => 'Utiliser les valeurs en pourcentage',
                                Swedish => 'Använd procentvärden',
                                Italian => 'Usa valori percentuale',
                                Dutch => 'Percentagewaarden gebruiken',
                                Spanish => 'Utilizar valores de porcentaje',
                                Norwegian => 'Bruk prosentverdier',
                                Portuguese => 'Utilizar valores da percentagem'}

    USE_MAXCALLS_TEXT       = { English_UK => 'Use fixed max. call values',
                                English_US  => 'Use fixed max. call values',
                                German  => 'Feste Werte für max. Anrufe verwenden',
                                French  => 'Utiliser les valeurs d\'appel fixes max',
                                Swedish => 'Använd fasta värden för högsta antal samtal',
                                Italian => 'Usa valori chiamata max. fissi',
                                Dutch => 'Vaste waarden voor max. aantal gesprekken gebruiken',
                                Spanish => 'Utilizar valores fijos de máx. de llamadas',
                                Norwegian => 'Bruk konstante verdier for maks. samtaler',
                                Portuguese => 'Utilizar valores de máx. de chamadas fixos'}
                                                                                          
    NO_VALUETYPE_AHT        = { English_UK => '<None>',
                                English_US  => '<None>',
                                German  => '<Kein>',
                                French  => '<Aucun>',
                                Swedish => '<Inget>',
                                Italian => '<nessuno>',
                                Dutch => '<Geen>',
                                Spanish => '<Ninguna>',
                                Norwegian => '<Ingen>',
                                Portuguese => '<Nenhum>'}
                            
    VALUETYPE_CALL_TEXT     = { English_UK => 'Processes',
                                English_US  => 'Processes',
                                German  => 'Prozesse',
                                French  => 'Opérations',
                                Swedish => 'Processer',
                                Italian => 'Operazioni',
                                Dutch => 'Processen',
                                Spanish => 'Operaciones',
                                Norwegian => 'Prosesser',
                                Portuguese => 'Operações'}

    VALUETYPE_AHT_TEXT      = { English_UK => 'Average handling time',
                                English_US  => 'Average handling time',
                                German  => 'Durchschnittliche Vorgangsdauer',
                                French  => 'Temps de traitement moyen',
                                Swedish => 'Genomsnittlig processtid',
                                Italian => 'Durata media di gestione',
                                Dutch => 'Gemiddelde procesduur',
                                Spanish => 'Duración media de la operación',
                                Norwegian => 'Gjennomsnittlig prosesstid',
                                Portuguese => 'Duração da operação média'}
                            
    QUEUE_PARAM_TEXT        = { English_UK => 'Queue parameters',
                                English_US  => 'Queue parameters',
                                German  => 'Queue-Parameter',
                                French  => 'Paramètres de file d\'attente',
                                Swedish => 'Köparametrar',
                                Italian => 'Parametri Servizi',
                                Dutch => 'Wachtrijparameters',
                                Spanish => 'Parámetros de datos en cola',
                                Norwegian => 'Køparametre',
                                Portuguese => 'Parâmetros da Fila'}

    SERVICE_LEVEL_TEXT      = { English_UK => 'Service level (%)',
                                English_US  => 'Service level (%)',
                                German  => 'Service-Level (%)',
                                French  => 'Niveau de service (%)',
                                Swedish => 'Service level (%)',
                                Italian => 'Service level (%)',
                                Dutch => 'Serviceniveau (%)',
                                Spanish => 'Nivel de servicio (%)',
                                Norwegian => 'Servicenivå (%)',
                                Portuguese => 'Nível de serviço (%)'}

    SERVICE_SEC_TEXT        = { English_UK => 'Service sec.',
                                English_US  => 'Service sec.',
                                German  => 'Service-Level (Sek.)',
                                French  => 'Service en s.',
                                Swedish => 'Service level (sek.)',
                                Italian => 'Service level (sec.)',
                                Dutch => 'Serviceniveau (sec.)',
                                Spanish => 'Nivel de servicio (segundos)',
                                Norwegian => 'Servicenivå (s.)',
                                Portuguese => 'Nível de serviço (seg.)'}

    ADD_TEXT                = { English_UK => 'Add (%)',
                                English_US  => 'Add (%)',
                                German  => 'Aufschlag (%)',
                                French  => 'Ajouter (%)',
                                Swedish => 'Tillägg (%)',
                                Italian => 'Aggiungi (%)',
                                Dutch => 'Toevoegen (%)',
                                Spanish => 'Suplemento (%)',
                                Norwegian => 'Legg til (%)',
                                Portuguese => 'Suplemento (%)'}

    MIN_STAFF_TEXT          = { English_UK => 'Minimum staff',
                                English_US  => 'Minimum staff',
                                German  => 'Mindestbesetzung',
                                French  => 'Ressources minimum',
                                Swedish => 'Minimibemanning',
                                Italian => 'Personale minimo',
                                Dutch => 'Minimumbezetting',
                                Spanish => 'Ocupación mínima',
                                Norwegian => 'Minimumsbemanning',
                                Portuguese => 'Ocupação mínima'}

    MAX_STAFF_TEXT          = { English_UK => 'Maximum staff',
                                English_US  => 'Maximum staff',
                                German  => 'Maximalbesetzung',
                                French  => 'Ressources maximum',
                                Swedish => 'Maximibemanning',
                                Italian => 'Personale massimo',
                                Dutch => 'Maximumbezetting',
                                Spanish => 'Ocupación máxima',
                                Norwegian => 'Maksimumsbemanning',
                                Portuguese => 'Ocupação máxima'}
                                
    DIVISION_WORK_TEXT      = { English_UK => 'Division of work volume',
                                English_US  => 'Division of work volume',
                                German  => 'Aufteilung der Arbeitsmenge',
                                French  => 'Répartition du volume de travail',
                                Swedish => 'Delning av arbetsvolym',
                                Italian => 'Divisione volume di lavoro',
                                Dutch => 'Verdeling van werkvolume',
                                Spanish => 'División del volumen de trabajo',
                                Norwegian => 'Deling av arbeidsvolum',
                                Portuguese => 'Divisão do volume de trabalho'}

    NO_ACTIVITY_SELECTED_TEXT = { English_UK => 'You have not selected an activity',
                                English_US  => 'You have not selected an activity',
                                German  => 'Sie haben keine Aktivität ausgewählt.',
                                French  => 'Vous n\'avez sélectionné aucune activité',
                                Swedish => 'Du har inte valt en aktivitet',
                                Italian => 'Non si è scelta un\'attività',
                                Dutch => 'U hebt geen activiteit gekozen',
                                Spanish => 'No ha seleccionado ninguna actividad',
                                Norwegian => 'Du har ikke valgt en aktivitet',
                                Portuguese => 'Não seleccionou uma actividade'}
                                                            
    NOOPENINGHOUR_TEXT      = { English_UK => 'There are no business hours for the planning unit: ',
                                English_US  => 'There are no business hours for the planning unit: ',
                                German  => 'Es sind keine Öffnungszeiten für die Planungseinheit vorhanden: ',
                                French  => 'Il n\'y a aucun horaire d’ouverture pour l’unité opérationnelle : ',
                                Swedish => 'Planeringsenheten har inga öppettider: ',
                                Italian => 'Non ci sono orari di apertura per l\'unità pianificativa: ',
                                Dutch => 'Er zijn geen openingstijden voor de eenheid: ',
                                Spanish => 'No hay horarios de apertura para la unidad de planificación: ',
                                Norwegian => 'Det finnes ingen åpningstider for planleggingsenheten: ',
                                Portuguese => 'Não existem horários de funcionamento para a unidade de planificação: '}
       
    REQ_ERROR_TEXT          = { English_UK => 'Problem encountered while reading requirement',
                                English_US  => 'Problem encountered while reading requirement',
                                German  => 'Beim Lesen des Bedarfs ist ein Problem aufgetreten',
                                French  => 'Un problème est survenu pendant la lecture du besoin',
                                Swedish => 'Problem påträffades vid läsning av behov',
                                Italian => 'Problema durante la lettura del fabbisogno',
                                Dutch => 'Er zijn problemen bij het lezen van de behoefte',
                                Spanish => 'Se ha producido un problema durante la lectura de la necesidad',
                                Norwegian => 'Det oppstod et problem under lesing av behov',
                                Portuguese => 'Erro encontrado durante a leitura da falta'}
                           
    REQ_NOT_WRITTEN_TEXT    = { English_UK => 'Requirement not written!',
                                English_US  => 'Requirement not written!',
                                German  => 'Bedarf wurde nicht geschrieben!',
                                French  => 'Le besoin n’est pas écrit !',
                                Swedish => 'Behov ej skrivet!',
                                Italian => 'Fabbisogno non scritto!',
                                Dutch => 'Er is geen behoefte geschreven!',
                                Spanish => 'La necesidad no está escrita!',
                                Norwegian => 'Behov er ikke angitt!',
                                Portuguese => 'A falta não está escrita!'}                         

    MONDAY_TEXT             = { English_UK => 'Monday',
                                English_US  => 'Monday',
                                German  => 'Montag',
                                French  => 'Lundi',
                                Swedish => 'Måndag',
                                Italian => 'Lunedì',
                                Dutch => 'Maandag',
                                Spanish => 'Lunes',
                                Norwegian => 'Mandag',
                                Portuguese => 'Segunda-feira'}                         

    TUESDAY_TEXT            = { English_UK => 'Tuesday',
                                English_US  => 'Tuesday',
                                German  => 'Dienstag',
                                French  => 'Mardi',
                                Swedish => 'Tisdag',
                                Italian => 'Martedì',
                                Dutch => 'Dinsdag',
                                Spanish => 'Martes',
                                Norwegian => 'Tirsdag',
                                Portuguese => 'Terça-feira'}       

    WEDNESDAY_TEXT          = { English_UK => 'Wednesday',
                                English_US  => 'Wednesday',
                                German  => 'Mittwoch',
                                French  => 'Mercredi',
                                Swedish => 'Onsdag',
                                Italian => 'Mercoledì',
                                Dutch => 'Woensdag',
                                Spanish => 'Miércoles',
                                Norwegian => 'Onsdag',
                                Portuguese => 'Quarta-feira'}     

    THURSDAY_TEXT           = { English_UK => 'Thursday',
                                English_US  => 'Thursday',
                                German  => 'Donnerstag',
                                French  => 'Jeudi',
                                Swedish => 'Torsdag',
                                Italian => 'Giovedì',
                                Dutch => 'Donderdag',
                                Spanish => 'Jueves',
                                Norwegian => 'Torsdag',
                                Portuguese => 'Quinta-feira'}     

    FRIDAY_TEXT             = { English_UK => 'Friday',
                                English_US  => 'Friday',
                                German  => 'Freitag',
                                French  => 'Vendredi',
                                Swedish => 'Fredag',
                                Italian => 'Venerdì',
                                Dutch => 'Vrijdag',
                                Spanish => 'Viernes',
                                Norwegian => 'Fredag',
                                Portuguese => 'Sexta-feira'}   
                                  
    SATURDAY_TEXT           = { English_UK => 'Saturday',
                                English_US  => 'Saturday',
                                German  => 'Samstag',
                                French  => 'Samedi',
                                Swedish => 'Lördag',
                                Italian => 'Sabato',
                                Dutch => 'Zaterdag',
                                Spanish => 'Sábado',
                                Norwegian => 'Lørdag',
                                Portuguese => 'Sábado'}   

    SUNDAY_TEXT             = { English_UK => 'Sunday',
                                English_US  => 'Sunday',
                                German  => 'Sonntag',
                                French  => 'Dimanche',
                                Swedish => 'Söndag',
                                Italian => 'Domenica',
                                Dutch => 'Zondag',
                                Spanish => 'Domingo',
                                Norwegian => 'Søndag',
                                Portuguese => 'Domingo'}                                       

    VER_TEXT                = { English_UK => 'Version',
                                English_US  => 'Version',
                                German  => 'Version',
                                French  => 'Version',
                                Swedish => 'Version',
                                Italian => 'Versione',
                                Dutch => 'Versie',
                                Spanish => 'Versión',
                                Norwegian => 'Versjon',
                                Portuguese => 'Versão'}   

    MIN_STAFF_TEXT_S        = { English_UK => 'Min. staff',
                                English_US  => 'Min.staff',
                                German  => 'Mindestbesetzung',
                                French  => 'Ressources min.',
                                Swedish => 'Min.bemanning',
                                Italian => 'Personale min.',
                                Dutch => 'Min. bezetting',
                                Spanish => 'Ocupación mín.',
                                Norwegian => 'Min.bemanning',
                                Portuguese => 'Ocupação mín.'}   
                            
    MAX_STAFF_TEXT_S        = { English_UK => 'Max. staff',
                                English_US  => 'Max.staff',
                                German  => 'Maximalbesetzung',
                                French  => 'Ressources max.',
                                Swedish => 'Max.bemanning',
                                Italian => 'Personale max.',
                                Dutch => 'Max. bezetting',
                                Spanish => 'Ocupación máx.',
                                Norwegian => 'Maks.bemanning',
                                Portuguese => 'Ocupação máx.'}   

    TARGET_QUEUE_DATA_WRITE_TEXT = {    English_UK => 'The employee requirement has been saved to the following queue/value type combination ',
                                        English_US  => 'The employee requirement has been saved to the following queue/value type combination ',
                                        German  => 'Der Mitarbeiterbedarf wurde unter der folgenden Queue-Wertetyp-Kombination gespeichert ',
                                        French  => 'Le besoin en personnel a été enregistré avec la combinaison de file d’attente / type de valeur suivante ',
                                        Swedish => 'Medarbetarbehovet har sparats i följande kombination av kö och värdetyp ',
                                        Italian => 'Il fabbisogno di dipendenti è stato salvato nella seguente combinazione servizio/tipo di parametro ',
                                        Dutch => 'De personeelsbehoefte is opgeslagen in de volgende queue-waardetype-combinatie ',
                                        Spanish => 'La necesidad de personal se ha guardado en la siguiente combinación de archivo de datos en cola y tipo de parámetro. ',
                                        Norwegian => 'Personalbehovet er lagret i følgende kombinasjon av kø/verditype ',
                                        Portuguese => 'A falta de empregados foi guardada na seguinte combinação de tipo fila/valor '}   
                          
    DISPLAYED_ROWS_TEXT         = { English_UK => 'Time-spans per day',
                                    English_US  => 'Time-spans per day',
                                    German  => 'Zeitabschnitte pro Tag',
                                    French  => 'Périodes par jour',
                                    Swedish => 'Antal tidssegment per dag',
                                    Italian => 'Fasce temporali al giorno',
                                    Dutch => 'Tijdvakken per dag',
                                    Spanish => 'Espacios de tiempo al día',
                                    Norwegian => 'Tidsavsnitt per dag',
                                    Portuguese => 'Intervalos de tempo por dia'}   

    DISPLAYED_DAYS_TEXT         = { English_UK => 'Number of days',
                                    English_US  => 'Number of days',
                                    German  => 'Anzahl Tage',
                                    French  => 'Nombre de jours',
                                    Swedish => 'Antal dagar',
                                    Italian => 'Numero di giorni',
                                    Dutch => 'Aantal dagen',
                                    Spanish => 'Número de días',
                                    Norwegian => 'Antall dager',
                                    Portuguese => 'Número de dias'}   

    DISPLAYED_PU_TEXT        = {    English_UK => 'Number of planning units',
                                    English_US  => 'Number of planning units',
                                    German  => 'Anzahl von Partnern',
                                    French  => 'Nombre d\'unités opérationnelles',
                                    Swedish => 'Antal planeringsenheter',
                                    Italian => 'Numero di unità pianificative',
                                    Dutch => 'Aantal eenheden',
                                    Spanish => 'Número de unidades de planificación',
                                    Norwegian => 'Antall planleggingsenheter',
                                    Portuguese => 'Número de unidades de planificação'}                        

    DISPLAY_MODE_TEXT         = {   English_UK => 'Consider each day of the week',
                                    English_US  => 'Consider each day of the week',
                                    German  => 'Wochentagsabhängig',
                                    French  => 'Considérer chaque jour de la semaine',
                                    Swedish => 'Överväg varje dag i veckan',
                                    Italian => 'Considera ciascun giorno della settimana',
                                    Dutch => 'Rekening houden met alle dagen van de week',
                                    Spanish => 'Tener en cuenta todos los días de la semana',
                                    Norwegian => 'Vurder hver dag i uken',
                                    Portuguese => 'Considerar cada dia da semana'}                      

    WEEKDAY_DEPENDENT           = { English_UK => 'Yes',
                                    English_US  => 'Yes',
                                    German  => 'Ja',
                                    French  => 'Oui',
                                    Swedish => 'Ja',
                                    Italian => 'Sì',
                                    Dutch => 'Ja',
                                    Spanish => 'Sí',
                                    Norwegian => 'Ja',
                                    Portuguese => 'Sim'}  

    WEEKDAY_INDEPENDENT         = { English_UK => 'No',
                                    English_US  => 'No',
                                    German  => 'Nein',
                                    French  => 'Non',
                                    Swedish => 'Nej',
                                    Italian => 'No',
                                    Dutch => 'Nee',
                                    Spanish => 'No',
                                    Norwegian => 'Nei',
                                    Portuguese => 'Não'}  

    QUEUE_TEXT                  = { English_UK => 'Queue',
                                    English_US  => 'Queue',
                                    German  => 'Queue',
                                    French  => 'File d\'attente',
                                    Swedish => 'Kö',
                                    Italian => 'Servizio',
                                    Dutch => 'Queue',
                                    Spanish => 'Archivo de datos en cola',
                                    Norwegian => 'Kø',
                                    Portuguese => 'Fila'}  
                           
    VALUETYPE_TEXT              = { English_UK => 'Value type',
                                    English_US  => 'Value Type',
                                    German  => 'Wertetyp',
                                    French  => 'Type de valeur',
                                    Swedish => 'Värdetyp',
                                    Italian => 'Tipo di parametro',
                                    Dutch => 'Waardetype',
                                    Spanish => 'Tipo de parámetro',
                                    Norwegian => 'Verditype',
                                    Portuguese => 'Tipo de valor'}  
                            
    FIX_VALUE_AHT_TEXT          = { English_UK => 'Fixed average handling time',
                                    English_US  => 'Fixed average handling time',
                                    German  => 'Konstante durchschnittliche Vorgangsdauer',
                                    French  => 'Temps de traitement moyen fixe',
                                    Swedish => 'Konstant processtid',
                                    Italian => 'Durata media costante di gestione',
                                    Dutch => 'Constante gemiddelde procesduur',
                                    Spanish => 'Duración media constante de la operación',
                                    Norwegian => 'Konstant gjennomsnittlig prosesstid',
                                    Portuguese => 'Duração média da operação constante'}  
 
    WRITE_TO_QUEUE_TEXT         = { English_UK => 'Save result to queue/value type combination as well?',
                                    English_US  => 'Save result to queue/value type combination as well?',
                                    German  => 'Ergebnis auch unter Queue-Wertetyp-Kombination speichern?',
                                    French  => 'Enregistrer aussi le résultat avec la combinaison de file d\'attente/type de valeur ?',
                                    Swedish => 'Vill du även spara resultatet i kombinationen av kö och värdetyp?',
                                    Italian => 'Salva il risultato anche nella combinazione servizio/tipo di parametro?',
                                    Dutch => 'Resultaat ook opslaan in queue-waardetype-combinatie?',
                                    Spanish => '¿Desea guardar el resultado también en archivo de datos en cola/tipo de parámetro?',
                                    Norwegian => 'Lagre resultat i kombinasjon av kø/verditype også?',
                                    Portuguese => 'Guardar resultado também na combinação de tipo fila/valor?'}  

   TARGET_QUEUE_DATA_ERROR_TEXT= {  English_UK => 'Problem: The requirement data cannot be saved to the following queue/value type combination ',
                                    English_US  => 'Problem: The requirement data cannot be saved to the following queue/value type combination ',
                                    German  => 'Fehler: Die Bedarfsdaten können nicht unter der folgenden Queue-Wertetyp-Kombination gespeichert werden ',
                                    French  => 'Erreur : Impossible d’enregistrer les données de besoin avec la combinaison de file d’attente / type de valeur suivante ',
                                    Swedish => 'Fel: Behovsdata kan inte sparas i följande kombination av kö och värdetyp ',
                                    Italian => 'Problema: Impossibile salvare i dati sul fabbisogno nella seguente combinazione servizio/tipo di parametro ',
                                    Dutch => 'Fout: De behoeftegegevens kunnen niet worden opgeslagen in de volgende queue-waardetype-combinatie ',
                                    Spanish => 'Problema: los datos de necesidad no se pueden guardar con la siguiente combinación de archivo de datos en cola/tipo de parámetro. ',
                                    Norwegian => 'Problem: Behovsdataene kan ikke lagres i følgende kombinasjon av kø/verditype ',
                                    Portuguese => 'Erro: Os dados da falta não podem ser guardados na seguinte combinação de tipo fila/valor '}     
                                
    ERROR_OCCURRED            = {   English_UK => 'An error has occurred:',
                                    English_US  => 'An error has occurred:',
                                    German  => 'Es ist ein Fehler aufgetreten:',
                                    French  => 'Une erreur est survenue :',
                                    Swedish => 'Ett fel har inträffat:',
                                    Italian => 'Si è verificato un errore:',
                                    Dutch => 'Er is een fout opgetreden:',
                                    Spanish => 'Se ha producido un error:',
                                    Norwegian => 'Det har oppstått en feil:',
                                    Portuguese => 'Ocorreu um erro:'}   

    NO_PLAN_UNITS_ERROR_TEXT  = {   English_UK => 'There are no planning units available in the system.',
                                    English_US  => 'There are no planning units available in the system.',
                                    German  => 'Im System sind keine Planungseinheiten verfügbar.',
                                    French  => 'Aucune unité opérationnelle n\’est disponible dans le système.',
                                    Swedish => 'Det finns inga planeringsenheter tillgängliga i systemet.',
                                    Italian => 'Non ci sono unità pianificative disponibili nel sistema.',
                                    Dutch => 'Er zijn geen eenheden in het systeem beschikbaar.',
                                    Spanish => 'No hay ninguna unidad de planificación disponible en el sistema.',
                                    Norwegian => 'Det er ingen tilgjengelige planleggingsenheter i systemet.',
                                    Portuguese => 'Não existem unidades de planificação disponíveis no sistema.'}   

    NO_QUEUES_ERROR_TEXT      = {   English_UK => 'There are no queues available in the system.',
                                    English_US  => 'There are no queues available in the system.',
                                    German  => 'Im System sind keine Queues verfügbar.',
                                    French  => 'Aucune file d\’attente n\’est disponible dans le système.',
                                    Swedish => 'Det finns inga köer tillgängliga i systemet.',
                                    Italian => 'Non ci sono servizi disponibili nel sistema.',
                                    Dutch => 'Er zijn geen queues in het systeem beschikbaar.',
                                    Spanish => 'No hay ningún dato de cola disponible en el sistema.',
                                    Norwegian => 'Det er ingen tilgjengelige køer i systemet.',
                                    Portuguese => 'Não existem filas disponíveis no sistema.'}   

    NO_VALUETYPES_ERROR_TEXT  = {   English_UK => 'There are no value types available in the system.',
                                    English_US  => 'There are no value types available in the system.',
                                    German  => 'Im System sind keine Wertetypen verfügbar.',
                                    French  => 'Aucun type de valeur n\’est disponible dans le système.',
                                    Swedish => 'Det finns inga värdetyper tillgängliga i systemet.',
                                    Italian => 'Non ci sono tipi di parametro disponibili nel sistema.',
                                    Dutch => 'Er zijn geen waardetypen in het systeem beschikbaar.',
                                    Spanish => 'No hay ningún tipo de parámetro disponible en el sistema.',
                                    Norwegian => 'Det er ingen tilgjengelige verdityper i systemet.',
                                    Portuguese => 'Não existem tipos de valores disponíveis no sistema.'}   

    NO_TASKTYPES_ERROR_TEXT   = {   English_UK => 'There are no activities available in the system.',
                                    English_US  => 'There are no activities available in the system.',
                                    German  => 'Im System sind keine Aktivitäten verfügbar.',
                                    French  => 'Aucune activité n\’est disponible dans le système.',
                                    Swedish => 'Det finns inga aktiviteter tillgängliga i systemet.',
                                    Italian => 'Non ci sono attività disponibili nel sistema.',
                                    Dutch => 'Er zijn geen activiteiten in het systeem beschikbaar.',
                                    Spanish => 'No hay ninguna actividad disponible en el sistema.',
                                    Norwegian => 'Det er ingen tilgjengelige aktiviteter i systemet.',
                                    Portuguese => 'Não existem actividades disponíveis no sistema.'}   

    SERVICE_LEVEL_TEXT_S        = { English_UK => 'Service level',
                                    English_US  => 'Service label',
                                    German  => 'Service-Level',
                                    French  => 'Niveau de service',
                                    Swedish => 'Service level',
                                    Italian => 'Service level',
                                    Dutch => 'Serviceniveau',
                                    Spanish => 'Nivel de servicio',
                                    Norwegian => 'Servicenivå',
                                    Portuguese => 'Nível de serviço'}   
                            
    ADD_TEXT_S                  = { English_UK => 'Add',
                                    English_US  => 'Add',
                                    German  => 'Hinzufügen',
                                    French  => 'Ajouter',
                                    Swedish => 'Lägg till',
                                    Italian => 'Aggiungi',
                                    Dutch => 'Toevoegen',
                                    Spanish => 'Insertar',
                                    Norwegian => 'Legg til',
                                    Portuguese => 'Suplemento'}    
                            
    CALL_DATA_ERROR_TEXT        = { English_UK => 'Problem encountered while reading processes',
                                    English_US  => 'Problem encountered while reading processes',
                                    German  => 'Beim Lesen der Vorgänge ist ein Problem aufgetreten',
                                    French  => 'Un problème est survenu pendant la lecture des opérations',
                                    Swedish => 'Problem påträffades vid läsning av processer',
                                    Italian => 'Problema durante la lettura delle operazioni',
                                    Dutch => 'Er zijn problemen bij het lezen van de processen',
                                    Spanish => 'Se ha producido un problema durante las operaciones de lectura',
                                    Norwegian => 'Det oppstod et problem under lesing av prosesser',
                                    Portuguese => 'Erro encontrado durante a leitura das operações'}   
   
    AHT_DATA_ERROR_TEXT         = { English_UK => 'Problem encountered while reading average handling time',
                                    English_US  => 'Problem encountered while reading average handling time',
                                    German  => 'Beim Lesen der durchschnittlichen Vorgangsdauer ist ein Problem aufgetreten',
                                    French  => 'Un problème est survenu pendant la lecture du temps de traitement moyen',
                                    Swedish => 'Problem påträffades vid läsning av genomsnittlig processtid',
                                    Italian => 'Problema durante la lettura della durata media di gestione',
                                    Dutch => 'Er zijn problemen bij het lezen van de gemiddelde procesduur',
                                    Spanish => 'Se ha producido un problema durante la lectura de la duración media de la operación',
                                    Norwegian => 'Det oppstod et problem under lesing av gjennomsnittlig prosesstid',
                                    Portuguese => 'Erro encontrado durante a leitura da duração da operação média'}                            
    

    NO_QUEUE_OPENING_TEXT       = { English_UK => 'No business hours exist for this queue!',
                                    English_US  => 'No business hours exist for this queue!',
                                    German  => 'Für diese Queue sind keine Öffnungszeiten vorhanden!',
                                    French  => 'Aucun horaire d\'ouverture n\'a été spécifié pour cette file d\'attente !',
                                    Swedish => 'Det finns inga öppettider för denna kö!',
                                    Italian => 'Non esistono orari di apertura per questo servizio',
                                    Dutch => 'Voor deze queue bestaan geen openingstijden!',
                                    Spanish => 'No existe ningún horario de apertura para este archivo de datos en cola!',
                                    Norwegian => 'Det finnes ingen åpningstider for denne køen!',
                                    Portuguese => 'Não existem horários de funcionamento para esta fila!'}    

    NO_VALID_TIME_ERROR_TEXT  = {   English_UK => 'The time slot value does not have a valid time in HH:MM!',
                                    English_US  => 'The time slot value does not have a valid time in HH:MM!',
                                    German  => 'Für den Intervallwert ist keine gültige Zeit in SS:MM verfügbar!',
                                    French  => 'L\'heure en HH:MM spécifiée pour le créneau horaire n\'est pas valide !',
                                    Swedish => 'Tidsperioden har inte rätt tid i formatet HH:MM!',
                                    Italian => 'Il valore dello spazio del tempo non ha un orario valido in HH:MM!',
                                    Dutch => 'De tijdvakwaarde heeft geen geldige tijd in uu:mm!',
                                    Spanish => 'El valor de intervalo no tiene una hora válida en HH:MM!',
                                    Norwegian => 'Tidsavsnittsverdien har ikke et gyldig klokkeslett i formatet TT:MM!',
                                    Portuguese => 'O valor do intervalo de tempo não apresenta uma hora válida em HH:MM!'}   

    NOT_ALL_CALLS_WARNING_TEXT = {  English_UK => 'Warning! It is not possible to handle all calls in this timeframe.',
                                    English_US  => 'Warning! It is not possible to handle all calls in this timeframe.',
                                    German  => 'Warnung! Es ist nicht möglich, alle Anrufe in diesem Zeitraum abzuwickeln.',
                                    French  => 'Avertissement ! Il n\'est pas possible de traiter tous les appels au cours de cette période.',
                                    Swedish => 'Varning! Det går inte att hantera alla samtal under den här tidsperioden.',
                                    Italian => 'Avviso Impossibile gestire tutte le chiamate in questo periodo.',
                                    Dutch => 'Waarschuwing! Het is niet mogelijk om alle gesprekken in deze periode te verwerken.',
                                    Spanish => 'Advertencia: no es posible gestionar todas las llamadas en este período.',
                                    Norwegian => 'Advarsel! Det er ikke mulig å håndtere alle samtaler i denne tidsperioden.',
                                    Portuguese => 'Aviso! Não é possível atender todas as chamadas neste período de tempo.'}                                                

    START_LARGER_ENDTIME_ERROR_TEXT   = {   English_UK => 'The start time is greater than the end time for a time frame.',
                                            English_US  => 'The start time is greater than the end time for a time frame.',
                                            German  => 'Für einen Zeitraum ist die Startzeit größer als die Endzeit.',
                                            French  => 'L\'heure de début doit être postérieure à l\'heure de fin dans une période.',
                                            Swedish => 'Starttiden är senare än sluttiden i en tidsperiod.',
                                            Italian => 'L\'ora d\'inizio è superiore all\'ora di fine per un periodo.',
                                            Dutch => 'De starttijd is later dan de eindtijd voor een periode.',
                                            Spanish => 'La hora de inicio es posterior a la hora final del período.',
                                            Norwegian => 'Starttidspunktet er senere enn sluttidspunktet for en tidsperiode.',
                                            Portuguese => 'A hora de início é superior à hora de conclusão para um período de tempo.'}    

    PERCENTAGE_LARGER_100_ERROR_TEXT  = {   English_UK => 'The percentage values must be numbers between 0.0 and 100.0.',
                                            English_US  => 'The percentage values must be numbers between 0.0 and 100.0.',
                                            German  => 'Die Prozentwerte müssen Zahlen zwischen 0,0 und 100,0 sein.',
                                            French  => 'Les valeurs en pourcentage doivent être des nombres compris entre 0.0 et 100.0.',
                                            Swedish => 'Det angivna procentvärdet måste vara siffror mellan 0,0 och 100,0.',
                                            Italian => 'Il valore della percentuale deve essere numeri compresi tra 0.0 e 100.0.',
                                            Dutch => 'De percentagewaarden moeten getallen tussen 0,0 en 100,0 zijn.',
                                            Spanish => 'Los valores de porcentaje deben ser números entre 0.0 y 100.0.',
                                            Norwegian => 'Prosentverdiene må være tall mellom 0,0 og 100,0.',
                                            Portuguese => 'Os valores de percentagem devem situar-se entre 0.0 e 100.0.'}    

    PERCENTAGE_SUM_NOT_100_ERROR_TEXT = {   English_UK => 'The sum of all percentage values in a row must be 100.0.',
                                            English_US  => 'The sum of all percentage values in a row must be 100.0.',
                                            German  => 'Der Summe aller Prozentwerte in einer Zeile muss 100,0 ergeben.',
                                            French  => 'La somme des valeurs en pourcentage sur une ligne doit être de 100.00.',
                                            Swedish => 'Summan av alla procentvärden på en rad måste vara 100.',
                                            Italian => 'La somma di tutti i valori della percentuale in una riga deve essere 100.0.',
                                            Dutch => 'De som van alle percentagewaarden in een rij moet 100,0 zijn.',
                                            Spanish => 'La suma de todos los valores de porcentaje debe ser igual a 100.0.',
                                            Norwegian => 'Summen av alle prosentverdier i en rad må være 100,0.',
                                            Portuguese => 'A soma de todos os valores de percentagem numa fila deve ser 100.0.'}    
                                                                                       
    PU_ACTIVITY_NOT_UNIQUE_ERROR_TEXT = {   English_UK => 'Planning Unit/Activity combination must not be used twice!',
                                            English_US  => 'Planning Unit/Activity combination must not be used twice!',
                                            German  => 'Planungseinheit-Aktivität-Kombination darf nicht zweimal verwendet werden!',
                                            French  => 'Vous ne pouvez pas utiliser deux fois une combinaison d\'activité et d\'unité opérationnelle !',
                                            Swedish => 'Kombinationen av planeringsenhet/aktivitet får inte användas två gånger!',
                                            Italian => 'La combinazione Unità pianificativa/Attività non deve essere usate due volte!',
                                            Dutch => 'De combinatie van eenheid/activiteit mag niet twee keer worden gebruikt!',
                                            Spanish => 'La combinación de Unidad de planificación/Actividad no se puede utilizar dos veces!',
                                            Norwegian => 'En kombinasjon av planleggingsenhet/aktivitet kan ikke brukes to ganger!',
                                            Portuguese => 'A combinação unidade de planificação/actividade não deve ser utilizada duas vezes!'}    

    PU_TIME_RASTER_DIFFER_ERROR_TEXT  = {   English_UK => 'All planning units must have the same time raster!',
                                            English_US  => 'All planning units must have the same time raster!',
                                            German  => 'Alle Planungseinheiten müssen dasselbe Zeitraster haben!',
                                            French  => 'Toutes les unités opérationnelles doivent avoir le même intervalle !',
                                            Swedish => 'Alla planeringsenheter måste ha samma tidsraster!',
                                            Italian => 'Tutte le unità pianificative devono avere lo stesso raster temporale!',
                                            Dutch => 'Alle eenheden moeten hetzelfde tijdraster hebben!',
                                            Spanish => 'Todas las unidades de planificación debe tener la misma trama de tiempo!',
                                            Norwegian => 'Alle planleggingsenheter må ha samme tidsraster!',
                                            Portuguese => 'Todas as unidades de planificação têm de ter o mesmo raster de tempo!'}  

    TIMESLOTS_OVERLAP_ERROR_TEXT      = {   English_UK => 'Timeslots for one day must not overlap!',
                                            English_US  => 'Timeslots for one day must not overlap!',
                                            German  => 'Intervalle für einen Tag dürfen sich nicht überlappen!',
                                            French  => 'Les créneaux d\'une journée ne doivent pas se chevaucher !',
                                            Swedish => 'Tidsperioderna för en dag får inte överlappa varandra!',
                                            Italian => 'Le fasce orarie di un giorno non devono sovrapporsi!',
                                            Dutch => 'Tijdvakken voor dezelfde dag mogen elkaar niet overlappen!',
                                            Spanish => 'Los intervalos de un día no deben solaparse!',
                                            Norwegian => 'Tidsavsnitt for én dag kan ikke overlappe!',
                                            Portuguese => 'Os intervalos de tempo de um dia não devem sobrepor-se!'}  

    ############################################################################
    #
    #   Method Name:-   getText
    #   Description:-   Gets the localised text.
    #   Parameters:-    Array of text values.
    #   Return Values:- Localised text.
    #
    ############################################################################
    def tr(aTextArray)

        return aTextArray[$ISPSLanguage]
    end
   
end #module Localize

class Array
def sum
  sum=0
  self.each {|val| sum += val}
  sum 
end

def min_interval
  min_index = 0
  self.each_index do |i|
    min_index = i if self[i] < self[min_index]
  end 
  min_index  
end#def

def max_interval
  max_index = 0
  self.each_index do |i|
    max_index = i if self[i] > self[max_index]
  end 
  max_index  
end#def



end#class array
