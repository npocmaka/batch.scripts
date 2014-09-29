:: http://stackoverflow.com/questions/25950181/why-for-f-sets-empty-values-for-repeated-numbers-in-the-rest-of-tokens

:: For /f command set empty value for each requested token in options section
:: Examples bellow

:::this prints - 1:[i] 2:[] 3:[] 4:[] 5:[] 6:[] 7:[]
for /f "tokens=1,1,1,1,1,1,1" %%a in ("i ii iii iv v vi vii") do (
    @echo 1:[%%a] 2:[%%b] 3:[%%c] 4:[%%d] 5:[%%e] 6:[%%f] 7:[%%g]
)

:::this prints - 1:[i] 2:[ii] 3:[iii] 4:[iv] 5:[] 6:[] 7:[%g]
for /f "tokens=2,3,1-4" %%a in ("i ii iii iv v vi vii") do (
    @echo 1:[%%a] 2:[%%b] 3:[%%c] 4:[%%d] 5:[%%e] 6:[%%f] 7:[%%g]
)

:::this prints - 1:[i] 2:[ii] 3:[iii] 4:[] 5:[] 6:[] 7:[%g]
for /f "tokens=1-3,1-3," %%a in ("i ii iii iv v vi vii") do (
    @echo 1:[%%a] 2:[%%b] 3:[%%c] 4:[%%d] 5:[%%e] 6:[%%f] 7:[%%g]
)
