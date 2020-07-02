/system script add name=UniFi source={
### Encontra servidor UniFi

:global unifiServer "controller.lagossoftware.com.br"
:global ipServer
:global ipToHex


:set ipServer [:put [:resolve $unifiServer];]; 

:if ($ipServer=[:toip $ipServer]) do={
  :local total ($ipServer);
  :local result "0x0104";
  :local hextable [:toarray "0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f"];
  :local total2 "";
  :local decimal;
  :local division;
  :local i;
  :local j;
  :for i from=1 to=[:len $total] step=1 do={
   :set j [:pick $total ($i-1) $i];
   :if (($j=".") or ($j="/")) do={:set j ","};
   :set total2 ($total2 . $j);
   };
  :set total2 [:toarray $total2];
  :for i from=0 to=3 step=1 do={
   :set j $i;
    #:if ($j<5) do={if ($j=0) do={:set j 4;} else={:set j ($j-1);};};
   :set decimal [:pick $total2 $j ($j+1)]
   :set division ($decimal / 16);
   :set result ($result . [:pick $hextable $division]);
   :set result ($result . [:pick $hextable ($decimal - (16 * $division))]);
   };
   :set ipToHex ("0x0104"$result);
} else={:put ("Ip do Servidor Desconhecido");}

:local unifi [:len [/ip dhcp-server option find where name=unifi]];

:if (unifi="1"  ) do={
 /ip dhcp-server option remove unifi
}

/ip dhcp-server option
add name=unifi code=43 value=$ipToHex

/ip dhcp-server network
set dhcp-option=unifi [find ]

}
