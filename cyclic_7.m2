loadPackage "Bertini"
--theDir = "/homes/combi/amendola/Documents/Macaulay/SymmetricMon/Test7/"
theDir = temporaryFileName()
makeDirectory(theDir)

uList={u0,u1,u2,u3,u4,u5,u6}
uVal= {0,0,0,0,0,0,1} --standard cyclic 7-roots problem
csi=exp(2*pi*ii/7)
--seventh primitive root of unity for starting solution
startSol={1,csi,csi^2,csi^3,csi^4,csi^5,csi^6}

R = QQ[x_0,x_1,x_2,x_3,x_4,x_5,x_6]

xList={"x_0","x_1","x_2","x_3","x_4","x_5","x_6"}

f0="-u0 + (x_0 +x_1 + x_2+ x_3+ x_4+ x_5+ x_6)"
f1="-u1 + (x_0*x_1 +x_1*x_2+ x_2*x_3 + x_3*x_4 + x_4*x_5 +x_5*x_6 +x_6*x_0)"
f2="-u2 + (x_0*x_1*x_2 +x_1*x_2*x_3+ x_2*x_3*x_4+ x_3*x_4*x_5 + x_4*x_5*x_6 + x_5*x_6*x_0 + x_6*x_0*x_1)"
f3="-u3 + (x_0*x_1*x_2*x_3 + x_1*x_2*x_3*x_4+ x_2*x_3*x_4*x_5+ x_3*x_4*x_5*x_6 + x_4*x_5*x_6*x_0 + x_5*x_6*x_0*x_1 + x_6*x_0*x_1*x_2)"
f4="-u4 + (x_0*x_1*x_2*x_3*x_4+ x_1*x_2*x_3*x_4*x_5+ x_2*x_3*x_4*x_5*x_6+ x_3*x_4*x_5*x_6*x_0+ x_4*x_5*x_6*x_0*x_1+ x_5*x_6*x_0*x_1*x_2+ x_6*x_0*x_1*x_2*x_3)"
f5="-u5 + (x_0*x_1*x_2*x_3*x_4*x_5 + x_0*x_1*x_2*x_3*x_4*x_6+ x_0*x_1*x_2*x_3*x_5*x_6 + x_0*x_1*x_2*x_4*x_5*x_6 + x_0*x_1*x_3*x_4*x_5*x_6 + x_0*x_2*x_3*x_4*x_5*x_6 + x_1*x_2*x_3*x_4*x_5*x_6)"
f6="-u6 + (x_0*x_1*x_2*x_3*x_4*x_5*x_6)"

--%%--Create a Bertini input file. 
makeB'InputFile(theDir,
    B'Polynomials=>{f0,f1,f2,f3,f4,f5,f6},
    AffVariableGroup=>xList,
    ParameterGroup=>uList,
    B'Configs=>{
	{ParameterHomotopy,2},
	{MPTYPE,2}})

writeStartFile(theDir,{startSol})
writeParameterFile(theDir,uVal,NameParameterFile=>"start_parameters")
--create random final_parameters: 
--1/2*for i in uVal list 2*random CC-1.3*random CC
uVal={.400937+.117529*ii, .0539081+.26916*ii, -.0106115+.485923*ii, .0670329+.201258*ii, .056302+.0222341*ii, -.0326684+.0681606*ii, .0271186-.0355098*ii}
writeParameterFile(theDir,uVal,NameParameterFile=>"final_parameters")
runBertini(theDir)
oneStartPoint=importSolutionsFile(theDir)

elapsedTime (
--%%--Use standard monodromy to collect new solutions 
 b'PHMonodromyCollect(theDir,
   MonodromyStartPoints=>oneStartPoint,
   MonodromyStartParameters=>uVal,
    NumberOfLoops=>100,
    NumSolBound=>924);
--924=14x66 is the goal.
)


elapsedTime (
--%%--Use decomposable monodromy to collect new solutions 
bertiniImageMonodromyCollect(theDir,
   MonodromyStartPoints=>oneStartPoint,
   MonodromyStartParameters=>uVal,
    NumberOfLoops=>100,
    NumSolBound=>66,
    AffVariableGroup=>xList,
   ImageCoordinates=>{"(x_0*x_2+ x_1*x_3+ x_2*x_4 + x_3*x_5 + x_4*x_6 +x_5*x_0 +x_6*x_1)"},   	     
    ReturnPoints=>true         );
)

--see solutions
readFile(theDir,"start",100000)
