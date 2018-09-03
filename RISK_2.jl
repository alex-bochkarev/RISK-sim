## RISK game problem
## Course IE 8090
## A. Bochkarev
## abochka@clemson.edu | telegram: @abochka

## the logic:
##  attacker attacks while he has armies
##  when no action is possible, the game ends

using Plots

const DEF_WINS = 1
const ATT_WINS = 0

const defender_armies = 1
const attacker_armies = 3

const Nmax = 1000000  # number of simulations

function play_game(defender, attacker)
    def_armies = defender
    att_armies = attacker

    while ((def_armies>=1) & (att_armies>1))
        ## attacker attacks:
        attacker_dice = maximum(rand(1:6,att_armies-1))
        defender_dice = maximum(rand(1:6,def_armies))
        
        if defender_dice>=attacker_dice
            att_armies-=1
        else
            def_armies-=1
        end

    end

    if (att_armies==1)
        # defender have won
        return 1
    else
        return 0
    end
end


prob_count = 0 # 
Ns = 1
N = 10

while N<=Nmax

    println("Simulation of N=",N," runs (games)")
    tic()
    defender_wins_count = @parallel (+) for i=1:N
        # play a game
        play_game(defender_armies,attacker_armies)
    end

    toc()
    prob_count = [prob_count defender_wins_count*100/N]
    Ns = [Ns N]
    N = N*10^0.5
end

println("The most accurate defense-win probability estimate:",@sprintf("%0.3f",prob_count[end]),"%")

println(Ns)
println(prob_count)

x = (log(10,Ns))'
y = prob_count'
asympt = repeat([prob_count[end]]; outer=length(y))

plot(x,[y asympt], title="Share of positive outcomes vs log No. of simulations", label=["Simulations" "Last value"])

