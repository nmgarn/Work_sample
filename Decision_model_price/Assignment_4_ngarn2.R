
#A retailer wants to price three different styles of sweaters. 
#Each sweater can be priced among the following five price points {$24.9, $29.9, $34.9, $39.9, $44.90}. 
#For each sweater and price-point combination, the retailer expects the demand to be as given in the table below.


#Prices ($)	Sweater Style 1	Sweater Style 2	Sweater Style 3
#24.9	150	170	250
#29.9	135	75	220
#34.9	120	60	190
#39.9	100	45	100
#44.9	60	40	90

#For example, if sweater style 1 is price at $44.90 then the retailer expects to sell 60 of these sweaters in the market.

#The retailer wants to find the optimal price for each sweater style such that their total revenue is maximized and the following constraints are satisfied:
  
#C1. Average price of the three sweater styles is less than or equal to $29.9.
#C2. Sweater style 1 cannot be priced lower than sweater style 2.
#C3. Sweater style 2 cannot be priced lower than sweater style 3.

#Formulate and solve the retailer’s price optimization problem as an integer program.


# use the below to avoid numbers being displayed in scientific notation
options("scipen"=8, "digits"=3)

# Using lpSolve and lpSolveAPI libraries
library(lpSolve)
library(lpSolveAPI)

#X11, X12, X13, X14, X15, X21, X22, X23, X24, X25, X31, X32, X33, X34, X35
Rue <- make.lp(0,15)

#Style Constraint
add.constraint(Rue, c(rep(1,5),rep(0,10)), "=",1) # Style 1
add.constraint(Rue, c(rep(0,5),rep(1,5),rep(0,5)), "=",1) #Style 2
add.constraint(Rue, c(rep(0,5),rep(0,5),rep(1,5)), "=",1) #Style 3


#Prices

P <- c(24.9, 29.9,34.9,39.9,44.9)

#Constraint 1

add.constraint(Rue, rep(P,3),"<=",29.9*3)

#Constraint 2

add.constraint(Rue, c(P, -P, rep(0,5)), ">=", 0)

#Constraint 3

add.constraint(Rue, c(rep(0,5),P, -P),  ">=", 0)
               


set.objfn(Rue, c(24.9*150,29.9*135,34.9*120,39.9*100, 44.9*60,
                 24.9*170,29.9*75,34.9*60,39.9*45, 44.9*40,
                 24.9*250,29.9*220,34.9*190,39.9*100, 44.9*90))

set.type(Rue,c(1:15),type = "binary")

lp.control(Rue, sense="max")
solve(Rue)

get.variables(Rue)

total_revenue<- get.objective(Rue)
total_revenue

