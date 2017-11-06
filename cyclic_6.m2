loadPackage "Bertini"
--theDir = "/homes/combi/amendola/Documents/Macaulay/SymmetricMon/Test6/"
theDir = temporaryFileName()
makeDirectory(theDir)

uList={u0,u1,u2,u3,u4,u5}
uVal= {0,0,0,0,0,1} --standard cyclic 6-roots problem
csi=exp(2*pi*ii/12)
--twelfth primitive root of unity for starting solution
startSol={csi,csi^3,csi^5,csi^7,csi^9,csi^11}

R = QQ[x_0,x_1,x_2,x_3,x_4,x_5]

xList={"x_0","x_1","x_2","x_3","x_4","x_5"}

f0="-u0 + x_0 +x_1 + x_2+ x_3+ x_4+ x_5"
f1="-u1 + x_0*x_1 +x_1*x_2+ x_2*x_3 + x_3*x_4 + x_4*x_5 +x_5*x_0"
f2="-u2 + x_0*x_1*x_2 +x_1*x_2*x_3+ x_2*x_3*x_4+ x_3*x_4*x_5 + x_4*x_5*x_0 + x_5*x_0*x_1"
f3="-u3 + x_0*x_1*x_2*x_3 + x_1*x_2*x_3*x_4+ x_2*x_3*x_4*x_5+ x_3*x_4*x_5*x_0 + x_4*x_5*x_0*x_1 + x_5*x_0*x_1*x_2"
f4="-u4 + x_0*x_1*x_2*x_3*x_4 + x_0*x_1*x_2*x_3*x_5+ x_0*x_1*x_2*x_4*x_5+ x_0*x_1*x_3*x_4*x_5 + x_0*x_2*x_3*x_4*x_5+ x_1*x_2*x_3*x_4*x_5"
f5="-u5 + x_0*x_1*x_2*x_3*x_4*x_5"

--%%--Create a Bertini input file. 
makeB'InputFile(theDir,
    B'Polynomials=>{f0,f1,f2,f3,f4,f5},
    AffVariableGroup=>xList,
    ParameterGroup=>uList,
    B'Configs=>{
	{ParameterHomotopy,2},
	{MPTYPE,2}})

writeStartFile(theDir,{startSol})
writeParameterFile(theDir,uVal,NameParameterFile=>"start_parameters")
--create random final_parameters: 
--1/2*for i in uVal list 2*random CC-1.3*random CC
uVal={.400937+.117529*ii, .0539081+.26916*ii, -.106115+.485923*ii, .670329+.201258*ii, .56302+.222341*ii, -.326684+.681606*ii}
writeParameterFile(theDir,uVal,NameParameterFile=>"final_parameters")
runBertini(theDir)
oneStartPoint=importSolutionsFile(theDir)

elapsedTime (
--%%--Use standard monodromy to collect new solutions 
 b'PHMonodromyCollect(theDir,
   MonodromyStartPoints=>oneStartPoint,
   MonodromyStartParameters=>uVal,
    NumberOfLoops=>100,
    NumSolBound=>156);
--156=12x13 is the goal.
)

elapsedTime (
--%%--Use decomposable monodromy to collect new solutions 
bertiniImageMonodromyCollect(theDir,
   MonodromyStartPoints=>oneStartPoint,
   MonodromyStartParameters=>uVal,
    NumberOfLoops=>100,
    NumSolBound=>13,
    AffVariableGroup=>xList,
   ImageCoordinates=>{"x_0*x_2+ x_1*x_3+ x_2*x_4 + x_3*x_5 + x_4*x_0 +x_5*x_1"},  	     
    ReturnPoints=>true         );
)

--see solutions
readFile(theDir,"start",100000)
