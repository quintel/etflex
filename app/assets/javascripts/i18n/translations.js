var I18n = I18n || {};
I18n.translations = {"nl":{"date":{"formats":{"default":"%d/%m/%Y","short":"%e %b","long":"%e %B %Y"},"day_names":["zondag","maandag","dinsdag","woensdag","donderdag","vrijdag","zaterdag"],"abbr_day_names":["zon","maa","din","woe","don","vri","zat"],"month_names":[null,"januari","februari","maart","april","mei","juni","juli","augustus","september","oktober","november","december"],"abbr_month_names":[null,"jan","feb","mar","apr","mei","jun","jul","aug","sep","okt","nov","dec"],"order":["day","month","year"]},"time":{"formats":{"default":"%a %d %b %Y %H:%M:%S %Z","short":"%d %b %H:%M","long":"%d %B %Y %H:%M"},"am":"'s ochtends","pm":"'s middags"},"support":{"array":{"words_connector":", ","two_words_connector":" en ","last_word_connector":" en "},"select":{"prompt":"Selecteer"}},"number":{"format":{"separator":",","delimiter":".","precision":2,"significant":false,"strip_insignificant_zeros":false},"currency":{"format":{"format":"%u%n","unit":"\u20ac","separator":",","delimiter":".","precision":2,"significant":false,"strip_insignificant_zeros":false}},"percentage":{"format":{"delimiter":""}},"precision":{"format":{"delimiter":""}},"human":{"format":{"delimiter":"","precision":3,"significant":true,"strip_insignificant_zeros":true},"storage_units":{"format":"%n %u","units":{"byte":{"one":"Byte","other":"Bytes"},"kb":"KB","mb":"MB","gb":"GB","tb":"TB"}},"decimal_units":{"format":"%n %u","units":{"unit":"","thousand":"duizend","million":"miljoen","billion":"miljard","trillion":"biljoen","quadrillion":"biljard"}}}},"datetime":{"distance_in_words":{"half_a_minute":"een halve minuut","less_than_x_seconds":{"one":"minder dan een seconde","other":"minder dan %{count} seconden"},"x_seconds":{"one":"1 seconde","other":"%{count} seconden"},"less_than_x_minutes":{"one":"minder dan een minuut","other":"minder dan %{count} minuten"},"x_minutes":{"one":"1 minuut","other":"%{count} minuten"},"about_x_hours":{"one":"ongeveer een uur","other":"ongeveer %{count} uur"},"x_days":{"one":"1 dag","other":"%{count} dagen"},"about_x_months":{"one":"ongeveer een maand","other":"ongeveer %{count} maanden"},"x_months":{"one":"1 maand","other":"%{count} maanden"},"about_x_years":{"one":"ongeveer een jaar","other":"ongeveer %{count} jaar"},"over_x_years":{"one":"meer dan een jaar","other":"meer dan %{count} jaar"},"almost_x_years":{"one":"bijna een jaar","other":"bijna %{count} jaar"}},"prompts":{"year":"jaar","month":"maand","day":"dag","hour":"uur","minute":"minuut","second":"seconde"}},"helpers":{"select":{"prompt":"Selecteer"},"submit":{"create":"%{model} toevoegen","update":"%{model} bewaren","submit":"%{model} opslaan"}},"errors":{"format":"%{attribute} %{message}","messages":{"inclusion":"is niet in de lijst opgenomen","exclusion":"is niet beschikbaar","invalid":"is ongeldig","confirmation":"komt niet met de bevestiging overeen","accepted":"moet worden geaccepteerd","empty":"moet opgegeven zijn","blank":"moet opgegeven zijn","too_long":"is te lang (maximaal %{count} tekens)","too_short":"is te kort (minimaal %{count} tekens)","wrong_length":"heeft onjuiste lengte (moet %{count} tekens lang zijn)","not_a_number":"is geen getal","not_an_integer":"moet een geheel getal zijn","greater_than":"moet groter zijn dan %{count}","greater_than_or_equal_to":"moet groter dan of gelijk zijn aan %{count}","equal_to":"moet gelijk zijn aan %{count}","less_than":"moet minder zijn dan %{count}","less_than_or_equal_to":"moet minder dan of gelijk zijn aan %{count}","odd":"moet oneven zijn","even":"moet even zijn","taken":"is al in gebruik","record_invalid":"Validatie mislukt: %{errors}","not_found":"niet gevonden","already_confirmed":"is reeds bevestigd","not_locked":"is niet gesloten"},"template":{"header":{"one":"%{model} niet opgeslagen: 1 fout gevonden","other":"%{model} niet opgeslagen: %{count} fouten gevonden"},"body":"Controleer de volgende velden:"}},"activerecord":{"errors":{"messages":{"inclusion":"is niet in de lijst opgenomen","exclusion":"is niet beschikbaar","invalid":"is ongeldig","confirmation":"komt niet met de bevestiging overeen","accepted":"moet worden geaccepteerd","empty":"moet opgegeven zijn","blank":"moet opgegeven zijn","too_long":"is te lang (maximaal %{count} tekens)","too_short":"is te kort (minimaal %{count} tekens)","wrong_length":"heeft onjuiste lengte (moet %{count} tekens lang zijn)","not_a_number":"is geen getal","not_an_integer":"moet een geheel getal zijn","greater_than":"moet groter zijn dan %{count}","greater_than_or_equal_to":"moet groter dan of gelijk zijn aan %{count}","equal_to":"moet gelijk zijn aan %{count}","less_than":"moet minder zijn dan %{count}","less_than_or_equal_to":"moet minder dan of gelijk zijn aan %{count}","odd":"moet oneven zijn","even":"moet even zijn","taken":"is al in gebruik","record_invalid":"Validatie mislukt: %{errors}"},"template":{"header":{"one":"%{model} niet opgeslagen: 1 fout gevonden","other":"%{model} niet opgeslagen: %{count} fouten gevonden"},"body":"Controleer de volgende velden:"},"full_messages":{"format":"%{attribute} %{message}"},"models":{"input":{"attributes":{"max":{"less_than_min":"De maximale waarde moet gelijk of groter dan de minimale waarde"}}}}}},"backstage":{"navigation":{"scenes":{"name":"Scenes","title":"Toevoegen, bewerken en verwijderen van Scenes"},"inputs":{"name":"Inputs","title":"Bewerk de inputs gedefinieerd door ETengine"},"queries":{"name":"Queries","title":"Bewerk de gqueries die worden gebruikt vanaf ETengine"},"props":{"name":"Props","title":"Toevoegen, bewerken en verwijderen van Props"},"sign_out":{"name":"Log uit","title":"Uitloggen bij ETflex"}}},"devise":{"failure":{"unauthenticated":"Je dient in te loggen of je in te schrijven.","unconfirmed":"Je dient eerst je account te bevestigen.","locked":"Je account is geblokkeerd.","invalid":"Ongeldig e-mail of wachtwoord.","invalid_token":"Ongeldig authenticiteit token.","timeout":"Je sessie is verlopen, log a.j.b. opnieuw in.","inactive":"Je account is nog niet geactiveerd."},"sessions":{"signed_in":"Je bent succesvol ingelogd.","signed_out":"Je bent succesvol uitgelogd."},"passwords":{"send_instructions":"Je ontvangt via e-mail instructies hoe je je wachtwoord moet resetten.","updated":"Je wachtwoord is gewijzigd. Je bent nu ingelogd."},"confirmations":{"send_instructions":"Je ontvangt via e-mail instructies hoe je je account kan bevestigen.","confirmed":"Je account is bevestigd."},"registrations":{"signed_up":"Je bent inschreven.","updated":"Je account gegevens zijn opgeslagen.","destroyed":"Je account is verwijderd, wellicht tot ziens!","signed_up_but_unconfirmed":"Een bericht met een bevestigingslink is verzonden naar uw e-mailadres. Open de link om uw account te activeren.","signed_up_but_inactive":"U heeft zich met succes aangemeld, maar uw account is nog niet geactiveerd.","signed_up_but_locked":"U heeft zich met succes aangemeld, maar uw account is geblokkeerd."},"unlocks":{"send_instructions":"Je ontvangt via e-mail instructies hoe je je account kan deblokkeren.","unlocked":"Je account is gedeblokkeerd. Je kan nu weer inloggen."},"mailer":{"confirmation_instructions":{"subject":"Bevestiging"},"reset_password_instructions":{"subject":"Wachtwoord resetten"},"unlock_instructions":{"subject":"Unlock instructies"}}},"inputs":{"new":"Nieuwe input","households_hot_water_micro_chp_share":"Micro-WKK","households_heating_heat_pump_ground_share":"Warmtepomp","households_hot_water_solar_water_heater_share":"Zonneboiler","households_insulation_level_old_houses":"Betere isolatie","households_hot_water_fuel_cell_share":"Brandstofcel","households_lighting_light_emitting_diode_share":"Zuinige lampen","number_of_pulverized_coal":"Steenkoolcentrales","number_of_gas_ccgt":"Aardgascentrales","number_of_nuclear_3rd_gen":"Kerncentrales","households_market_penetration_solar_panels":"Zonnepanelen","number_of_wind_offshore":"Windmolens","transport_cars_electric_share":"Elektrische auto's","green_gas_total_share":"Groen gas"},"loading":"Bezig met laden","loadingMsg":"Even geduld het duurt niet lang...","etm":"Energietransitiemodel","etm_light":"Energietransitiemodel light","navigation":{"scenes":"Scenes","inputs":"Inputs","queries":"Queries","props":"Props","loading":"Loading","sign_out":"Afmelden","info":"Informatie","settings":"Instellingen","region":"Gebied","end_year":"Toekomstjaar","locale":"Taal","switch_to":"Schakel over naar","reset_model":"Reset je scenario","sign_in":"Meld je aan","account":"Uw account","about":"Een energiespel met echte cijfers","feedback":"Wat vind je van dit spel","privacy":"Wat doen we met je gegevens","etmodel":"Door naar het volgende level van dit spel"},"words":{"sign_in_to_account":"Meld u aan bij uw account","no_account":"Heb je nog geen account?","email_address":"E-mailadres","password":"Wachtwoord","confirm_password":"Bevestig wachtwoord","remember_me":"Onthoud mijn login","sign_in":"Aanmelden","sign_in_long":"Meld u aan bij mijn account","sign_up":"Meld je nu aan","ago":"geleden","anonymous":"Anonieme Bezoeker","by":"Door","high_scores":"Hoge scores","loading":"Het laden"},"magnitudes":{"million":"%{amount} miljoen","billion":"%{amount} miljard"},"oops":"Sorry, er gaat iets fout","frontPage":"Terug naar de homepage","fourOhFour":"De pagina die je zocht kan niet worden gevonden.","scenes":{"etlite":{"savings":"Besparingen","production":"Productie","supply":"Aanbod","demand":"Vraag","balanced":"Balans","supplyExcess":"Aanbod te hoog","demandExcess":"Vraag te hoog","renewables":"Hernieuwbaar","emissions":"CO2","costs":"Kosten","score":"Score","reliability":"Betrouwbaar","billion":"miljard","landingTitle":"Hoe ziet jouw <strong>Energietoekomst</strong> er uit?","landingFuture":"Energietoekomst","landingSubtitle":"... en kun je de hoogste score halen?","landingButton":"Maak je eigen toekomst!"}},"sponsoredBy":"Gesponsord door","leading_partner":"Leading partner van het Energietransitiemodel","locales":{"nl":"Nederlands","en":"Engels","de":"Duits"},"regions":{"nl":"Nederland","uk":"Verenigd Koninkrijk","de":"Duitsland","pl":"Polen","ro":"Roemenie","za":"Zuid-Afrika","tr":"Turkije","nl-drenthe":"Drenthe","nl-flevoland":"Flevoland","nl-friesland":"Friesland","nl-gelderland":"Gelderland","nl-groningen":"Groningen","nl-limburg":"Limburg","nl-noord-brabant":"Noord-Brabant","nl-noord-holland":"Noord-Holland","nl-overijssel":"Overijssel","nl-utrecht":"Utrecht","nl-zeeland":"Zeeland","nl-zuid-holland":"Zuid-Holland","nl-noord":"North Netherlands","grs":"Groningen (stad)","ame":"Ameland","ams":"Amsterdam","be-vlg":"Vlaanderen","br":"Brandenburg"},"legacy_browser":{"title":"U gebruikt een oude browser.","continue":"Toch doorgaan","message":"De browser die u gebruikt is vrij oud en wordt niet volledig ondersteund door deze website. Je mag doorgaan als je wilt, maar wij raden ofwel het upgraden van uw huidige browser, of overwegen te wisselen om ofwel Google Chrome of Mozilla Firefox \u2013 beide zijn gratis.\n"},"props":{"co2_emissions":{"header":"Je stoot (Q:total_co2_emissions) ton aan CO<sub>2</sub> uit","body":"Auto's, verwarmingen en electriciteitscentrales stoten koolstofmonoxide uit. Volgens veel klimaatwetenschappers, heeft een grote toename in CO<sub>2</sub>-uitstoot gedurende de laatste 200 jaar er voor gezorgd dat het klimaat langszaam opwarmt en dat de poolkappen smelten\nProbeer de uitstoot van CO<sub>2</sub> zo veel mogelijk te beperken om een zo hoog mogelijke score te krijgen. Je kan echter nooit op nul uitkomen, omdat er ook veel uitstoot is die niet wordt bepaald door je schuifjes op deze pagina (denk aan vrachtauto's, de industrie, etctera.)"},"costs":{"header":"Je geeft ieder jaar (Q:total_costs) euro uit aan energie!","body":"This includes all the energy used to make exported products and the exported energy itself."},"score":{"header":"Je scoort (Q:etflex_score) punten.","body":"Je score gaat omhoog als je kosten, CO<sub>2</sub> en nucleair afval dalen, en als je duurzaamheid en betrouwbaarheid stijgen. Ook als je te veel inzet op een opwekkingstechniek daalt je score en als je een onbalans hebt tussen vraag en aanbod."},"reliability":{"header":{"on":"Je energievoorziening is betrouwbaar!","off":"Oh nee, je zit weleens in het donker met jouw instelling."},"body":"Hernieuwbare bronnen zijn minder goed voorspelbaar dan (fossiele) centrales, want soms schijnt de zon niet of waait het niet. Dit betekent dat je er niet van uit kan gaan dat de windmolens en de zonnepanelen elektriciteit leveren op het moment dat je wil internetten, tv wil kijken, of de wasmachine aan wil zetten. Tenzij je die energie natuurlijk ergens kan opslaan..."},"renewability":{"header":"(Q:renewability) deel van je energievoorziening is duurzaam","body":"Wil je duurzamere energie maken? Kies dan voor wind, zon of meng meer 'groen' gas bij.\nAls je nog meer mogelijkheden wilt hebben om het duurzaamheidspercentage te verhogen, ga dan naar de profesionele versie van het Energietransitiemodel, daar kun je o.a. ook de transportsector en de industriesector (verder) proberen te verduurzamen."},"supply_demand":{"name":"Saldo van Vraag en Aanbod"},"car":{"name":"Eco Car / SUV","info":{"eco":"In jouw scenario zijn er meer dan 1 miljoen elektrische auto's!","suv":"In jouw scenario heb je nu nog 'maar' (Q:number_of_electric_cars) elektrische auto's. Als je meer elektrische auto's voorziet, probeer dan het percentage elektrische auto's te verhogen zonder dat er een tekort aan elektriciteit ontstaat."}},"city":{"name":"Futuristische Stad"},"eco_buildings":{"name":"Eco-Gebouwen / Quarry"},"turbines":{"name":"Windturbines / Kolen Power Plant"},"energy_sources":{"name":"Energiebronnen"},"geothermal_pipeline":{"name":"Geothermie"},"ground":{"name":"Grond"},"solar_heater":{"name":"Zonneboiler"}}},"en":{"date":{"formats":{"default":"%Y-%m-%d","short":"%b %d","long":"%B %d, %Y"},"day_names":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],"abbr_day_names":["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],"month_names":[null,"January","February","March","April","May","June","July","August","September","October","November","December"],"abbr_month_names":[null,"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"order":["year","month","day"]},"time":{"formats":{"default":"%a, %d %b %Y %H:%M:%S %z","short":"%d %b %H:%M","long":"%B %d, %Y %H:%M"},"am":"am","pm":"pm"},"support":{"array":{"words_connector":", ","two_words_connector":" and ","last_word_connector":", and "}},"errors":{"format":"%{attribute} %{message}","messages":{"inclusion":"is not included in the list","exclusion":"is reserved","invalid":"is invalid","confirmation":"doesn't match confirmation","accepted":"must be accepted","empty":"can't be empty","blank":"can't be blank","too_long":"is too long (maximum is %{count} characters)","too_short":"is too short (minimum is %{count} characters)","wrong_length":"is the wrong length (should be %{count} characters)","not_a_number":"is not a number","not_an_integer":"must be an integer","greater_than":"must be greater than %{count}","greater_than_or_equal_to":"must be greater than or equal to %{count}","equal_to":"must be equal to %{count}","less_than":"must be less than %{count}","less_than_or_equal_to":"must be less than or equal to %{count}","odd":"must be odd","even":"must be even","expired":"has expired, please request a new one","not_found":"not found","already_confirmed":"was already confirmed, please try signing in","not_locked":"was not locked","not_saved":{"one":"1 error prohibited this %{resource} from being saved:","other":"%{count} errors prohibited this %{resource} from being saved:"}}},"number":{"format":{"separator":".","delimiter":",","precision":3,"significant":false,"strip_insignificant_zeros":false},"currency":{"format":{"format":"%u%n","unit":"$","separator":".","delimiter":",","precision":2,"significant":false,"strip_insignificant_zeros":false}},"percentage":{"format":{"delimiter":""}},"precision":{"format":{"delimiter":""}},"human":{"format":{"delimiter":"","precision":3,"significant":true,"strip_insignificant_zeros":true},"storage_units":{"format":"%n %u","units":{"byte":{"one":"Byte","other":"Bytes"},"kb":"KB","mb":"MB","gb":"GB","tb":"TB"}},"decimal_units":{"format":"%n %u","units":{"unit":"","thousand":"Thousand","million":"Million","billion":"Billion","trillion":"Trillion","quadrillion":"Quadrillion"}}}},"datetime":{"distance_in_words":{"half_a_minute":"half a minute","less_than_x_seconds":{"one":"less than 1 second","other":"less than %{count} seconds"},"x_seconds":{"one":"1 second","other":"%{count} seconds"},"less_than_x_minutes":{"one":"less than a minute","other":"less than %{count} minutes"},"x_minutes":{"one":"1 minute","other":"%{count} minutes"},"about_x_hours":{"one":"about 1 hour","other":"about %{count} hours"},"x_days":{"one":"1 day","other":"%{count} days"},"about_x_months":{"one":"about 1 month","other":"about %{count} months"},"x_months":{"one":"1 month","other":"%{count} months"},"about_x_years":{"one":"about 1 year","other":"about %{count} years"},"over_x_years":{"one":"over 1 year","other":"over %{count} years"},"almost_x_years":{"one":"almost 1 year","other":"almost %{count} years"}},"prompts":{"year":"Year","month":"Month","day":"Day","hour":"Hour","minute":"Minute","second":"Seconds"}},"helpers":{"select":{"prompt":"Please select"},"submit":{"create":"Create %{model}","update":"Update %{model}","submit":"Save %{model}"},"button":{"create":"Create %{model}","update":"Update %{model}","submit":"Save %{model}"}},"activerecord":{"errors":{"messages":{"taken":"has already been taken","record_invalid":"Validation failed: %{errors}"},"models":{"scenario":{"attributes":{"user_id":{"blank":"can't be blank when no guest UID is set"}}},"input":{"attributes":{"max":{"less_than_min":"The maximum value must be equal or greater than the minimum value"}}}}}},"devise":{"failure":{"already_authenticated":"You are already signed in.","unauthenticated":"You need to sign in or sign up before continuing.","unconfirmed":"You have to confirm your account before continuing.","locked":"Your account is locked.","invalid":"Invalid email or password.","invalid_token":"Invalid authentication token.","timeout":"Your session expired, please sign in again to continue.","inactive":"Your account was not activated yet."},"sessions":{"signed_in":"Signed in successfully.","signed_out":"Signed out successfully."},"passwords":{"send_instructions":"You will receive an email with instructions about how to reset your password in a few minutes.","updated":"Your password was changed successfully. You are now signed in.","updated_not_active":"Your password was changed successfully.","send_paranoid_instructions":"If your e-mail exists on our database, you will receive a password recovery link on your e-mail"},"confirmations":{"send_instructions":"You will receive an email with instructions about how to confirm your account in a few minutes.","send_paranoid_instructions":"If your e-mail exists on our database, you will receive an email with instructions about how to confirm your account in a few minutes.","confirmed":"Your account was successfully confirmed. You are now signed in."},"registrations":{"signed_up":"Welcome! You have signed up successfully.","signed_up_but_unconfirmed":"A message with a confirmation link has been sent to your email address. Please open the link to activate your account.","signed_up_but_inactive":"You have signed up successfully. However, we could not sign you in because your account is not yet activated.","signed_up_but_locked":"You have signed up successfully. However, we could not sign you in because your account is locked.","updated":"You updated your account successfully.","update_needs_confirmation":"You updated your account successfully, but we need to verify your new email address. Please check your email and click on the confirm link to finalize confirming your new email address.","destroyed":"Bye! Your account was successfully cancelled. We hope to see you again soon."},"unlocks":{"send_instructions":"You will receive an email with instructions about how to unlock your account in a few minutes.","unlocked":"Your account was successfully unlocked. You are now signed in.","send_paranoid_instructions":"If your account exists, you will receive an email with instructions about how to unlock it in a few minutes."},"omniauth_callbacks":{"success":"Successfully authorized from %{kind} account.","failure":"Could not authorize you from %{kind} because \"%{reason}\"."},"mailer":{"confirmation_instructions":{"subject":"Confirmation instructions"},"reset_password_instructions":{"subject":"Reset password instructions"},"unlock_instructions":{"subject":"Unlock Instructions"}}},"backstage":{"navigation":{"scenes":{"name":"Scenes","title":"Add, edit, and remove Scenes"},"inputs":{"name":"Inputs","title":"Edit the inputs defined by ETengine"},"queries":{"name":"Queries","title":"Edit the queries used by ETengine"},"props":{"name":"Props","title":"Add, edit, and remove Props"},"sign_out":{"name":"Sign Out","title":"Sign out of your ETflex account"},"front_end":{"name":"Front End","title":"Go to the Front End"}}},"loading":"Loading","loadingMsg":"The application is being loaded. One moment; it won't be long!","etm":"Energy Transition Model","etm_light":"Energy Transition Model light","navigation":{"scenes":"Scenes","inputs":"Inputs","queries":"Queries","props":"Props","loading":"Loading","sign_out":"Sign out","info":"Information","settings":"Settings","region":"Region/Country","end_year":"End Year","locale":"Language","switch_to":"Switch to","reset_model":"Reset your scenario","sign_in":"Sign in","account":"Account","about":"About this application","feedback":"Feedback","privacy":"Privacy statement","etmodel":"Open in the Energy Transition Model"},"words":{"sign_in_to_account":"Sign in to your account","no_account":"Don't have an account?","email_address":"E-mail address","password":"Password","confirm_password":"Confirm password","remember_me":"Remember me","sign_in":"Sign in","sign_in_long":"Sign in to my account","sign_up":"Sign up","ago":"ago","anonymous":"Anonymous Visitor","by":"By","high_scores":"High scores","loading":"Loading"},"magnitudes":{"million":"%{amount} million","billion":"%{amount} billion"},"oops":"Whoops","frontPage":"Back to the homepage","fourOhFour":"The page you were looking for could not be found. Sorry about that&hellip;","scenes":{"etlite":{"savings":"Savings","production":"Production","supply":"Supply","demand":"Demand","balanced":"Balanced","supplyExcess":"Supply too high","demandExcess":"Demand too high","renewables":"Renewables","emissions":"Emissions","costs":"Costs","score":"Score","reliability":"Reliability","billion":"billion","landingTitle":"What does your <strong>%{future}</strong> look like?","landingFuture":"Energy Future","landingSubtitle":"... and can you get high score?","landingButton":"Create your own future!"}},"sponsoredBy":"Sponsored by","leading_partner":"Leading partner of the Energy Transition Model","locales":{"nl":"Dutch","en":"English","de":"German"},"regions":{"nl":"Netherlands","uk":"United Kingdom","de":"Germany","pl":"Poland","ro":"Romania","za":"South Africa","tr":"Turkey","nl-drenthe":"Drenthe","nl-flevoland":"Flevoland","nl-friesland":"Friesland","nl-gelderland":"Gelderland","nl-groningen":"Groningen","nl-limburg":"Limburg","nl-noord-brabant":"Noord-Brabant","nl-noord-holland":"Noord-Holland","nl-overijssel":"Overijssel","nl-utrecht":"Utrecht","nl-zeeland":"Zeeland","nl-zuid-holland":"Zuid-Holland","nl-noord":"North Netherlands","grs":"Groningen (city)","ame":"Ameland","ams":"Amsterdam","be-vlg":"Flanders","br":"Brandenburg"},"legacy_browser":{"title":"You are using an old browser.","continue":"Continue anyway","message":"The browser you are using is quite old and is not fully supported by this website. You may continue if you wish, but we recommend either upgrading your current browser, or consider swapping to either Google Chrome or Mozilla Firefox \u2013 both are free.\n"},"inputs":{"new":"New input","households_behavior_standby_killer_turn_off_appliances":"Switch off appliances","households_heating_heat_pump_ground_share":"Heat pump for the home","households_hot_water_micro_chp_share":"Micro-CHP for hot water","households_hot_water_solar_water_heater_share":"Solar water heater","households_hot_water_fuel_cell_share":"Fuel cell for hot water","households_insulation_level_old_houses":"Better insulation","households_lighting_light_emitting_diode_share":"Low-energy lighting","number_of_pulverized_coal":"Coal-fired power plants","number_of_gas_ccgt":"Gas-fired power plants","number_of_nuclear_3rd_gen":"Nuclear power plants","households_market_penetration_solar_panels":"Solar panels","number_of_wind_offshore":"Wind turbines","policy_area_biomass":"Biomass","transport_cars_electric_share":"Electric cars","green_gas_total_share":"Green gas"},"props":{"co2_emissions":{"header":"You emit (Q:total_co2_emissions) tonnes of CO<sub>2</sub>","body":"When fuel is burnt by cars, heaters or power plants, they emit carbon dioxide. A big increase in CO<sub>2</sub> emissions during the last 200 years is assumed to be responsible for global warming and melting polar ice caps by scientists.\nTry to reduce this number to get a higher score, but you cannot get to zero, because some emissions (for example from trucks, industry, etcetera) cannot be influenced with sliders here. (You might want to go to the professional model of the ETM to try to further decrease this number.)"},"costs":{"header":"You spend (Q:total_costs) euros on energy every year!","body":"This includes all the energy used to make exported products and the exported energy itself."},"score":{"header":"You score (Q:etflex_score) points","body":"Your score goes up when you decrease costs, CO<sub>2</sub> emissions and nuclear waste, and when you increase renewabilty and reliability. Relying too much on one technology or option decreases your score. Good balance between supply and demand increases it."},"reliability":{"header":{"on":"You have a reliable energy supply!","off":"Oh no, you'll be in the dark now and then with your current set-up!"},"body":"Renewable power is less predictable than power from (fossil) power plants, because sometimes there is no wind or sunshine. This means you cannot be sure to have power, unless you manage to store it somewhere or have a backup plan."},"renewability":{"header":"(Q:renewability) of your energy is renewable.","body":"Do you want to produce more renewable types of energy? Then build more wind, solar or add more green gas to your gas network.\nIf you want to increase the number above 20%, you will need to go to the (free) professional version of the ETM in order to adjust setting in other sectors, such as transportationa and the industry."},"supply_demand":{"header":"Balance of Supply and Demand"},"car":{"name":"What type of cars will prevail in the streets in the future?","info":{"eco":"In your scenario, there are more than a million electric cars in the Netherlands in 2040! Electric cars will be abundantly visible in the streets.","suv":"In the current situation there are only (Q:number_of_electric_cars) electric cars and X.XX million fossil-fueled cars in the Netherlands in 2040. If you want to change the division, try to increase the percentage of electric cars to see the impact."}},"city":{"name":"Futuristic City"},"eco_buildings":{"name":"Eco-Buildings / Quarry"},"turbines":{"name":"Wind Turbines / Coal Power Plant"},"energy_sources":{"name":"Energy Sources"},"geothermal_pipeline":{"name":"Geothermal pipeline"},"ground":{"name":"Ground"},"solar_heater":{"name":"Solar Heater"}},"simple_form":{"yes":"Yes","no":"No","required":{"text":"required","mark":"*"},"error_notification":{"default_message":"Some errors were found, please take a look:"},"labels":{"input":{"remote_id":"ETengine input ID","key":"Key","min":"Minimum value","max":"Maximum value","start":"Starting value","step":"Step by","unit":"Unit"},"scene_input":{"remote_id":"ETengine input ID","key":"Key","min":"Minimum value","max":"Maximum value","start":"Starting value","step":"Step by","unit":"Unit","input":"Input"}}}}};