begin
  t=95/665 # The multiplicative constant to approximate
  s=0 # The number of bits to shift
  m=Int(round(t*(2^s))) # The number to multiply by
  a=m >> s # The effective value of the approximation
  er=abs(a-t)/t # The error in the approximation
  while (er > 1/100) # Error still too large
    #= Current maximum error is set to 1%, but this
      error depends on what you are multiplying
      (i.e. for a range from 0 to 1023, the error
      should be less than 1/1023) =#
    s = s+1 # Increase the amount being shifted
    m = Int(round(t*(2^s))) # Recalculate multiplication
    a = m/(2^s) # Recalculate value of the approximation
    er=abs(a-t)/t # Recalculate the error
    println(a," ",er) # Print the approximation, and the error
  end
  println(m," / ",2^s," (",s,") = ",a," with error ",100*er,"%.")
end
