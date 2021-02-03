// determine how many events to generate, for each nucleon,
// based on requested total number of events `Ntot`

void calculateNev(Long64_t Ntot=1970000) {

  // cross sections [nb]
  Double_t CSp = 80.53;
  Double_t CSn = 63.27;

  // number of protons and neutrons in target
  // ^14 NH3
  Double_t Tp = 7 + 3; // 7 from N, 3 from H3
  Double_t Tn = 7;
  // ^15 NH3
  //Tn++;
  
  // calculate "base number" of events for each nucleon
  /* Ntot = Tp*Bp + Tn*Bn
   * our goal is to determine Tp*Bp and Tn*Bn, given Ntot
   * CSp/CSn = Bp/Bn  -->  Bn = Bp*CSn/CSp
   * Ntot = Tp*Bp + Tn*Bp*CSn/CSp
   * therefore Bp = Ntot/(Tp+Tn*CSn/CSp)
   */
  Double_t Bp = Ntot/(Tp+Tn*CSn/CSp);
  Double_t Bn = Bp*CSn/CSp;
  
  // number of events to generate on each target:
  Long64_t Np = (Long64_t) Tp*Bp;
  Long64_t Nn = (Long64_t) Tn*Bn;
  printf("generate %lld on proton\n",Np);
  printf("generate %lld on neutron\n",Nn);
  printf("total = %lld\n",Np+Nn);
};
