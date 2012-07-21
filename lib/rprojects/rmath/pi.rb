module Rprojects
  module RMath
    # Implementation of S.Rabinowitz and S.Wagon's Spigot Algorithm to
    # compute the digits of PI. Adapted from Michael Eisermann - Institut
    # Fourier, Université Joseph Fourier, Grenoble, France
	  #
	  # Below comments was taken from original implementation:
    #
    # Le programme suivant est une traduction en C++ du programme
    # présenté par S.Rabinowitz et S.Wagon à la fin de leur article
    #   "A spigot algorithm for the digits of pi",
    #   American Mathematical Monthly 102 (1995), no. 3, 195--203.
    # Il a été conçu pour calculer jusqu'à 1000 chiffres de pi.
    #
    # Avertissement :
    # Dans le programme de Rabinowitz et Wagon, certaines imprécisions
    # se sont introduites.  Tout d'abord on constate que des chiffres
    # terminaux valant 9 ne sont jamais affichés, car le programme ne
    # peut garantir leur correction.  Il semble donc honnête de ne pas
    # les afficher : au pire, si l'on exige une précision donnée,
    # il faut tout recalculer avec légèrement plus de chiffres.
    #
    # Plus grave est le choix erroné de la variable m,
    # qui représente la longueur de la série approchant pi.
    # La longueur  m = (10*n)/3  mène à une précision insuffisante.
    # La longueur  m = (10*n)/3 + 1  par contre devrait suffire.
    #
    # À cause de cette erreur, certains chiffres terminaux peuvent être
    # erronés sans que l'utilisateur s'aperçoive.  Ceci arrive déjà pour
    # n=1, ce qui est très embarrassant mais assez facile à détecter.
    # Ensuite pour n=32 le dernier chiffre affiché est erroné, ce qui
    # est plus embêtant : l'utilisateur ne saurait pas, en général,
    # que le 32ème chiffre devrait valoir 5 et non 4.
    #
    # Ceci ne diminue en rien le travail de S.Rabinowitz et S.Wagon,
    # mais souligne l'importance d'une implémentation soigneuse.
    #==========================================================================
    def rabinowitz_wagon(n)
      res = ""
      m = (10*n)/3+1                # choisir une longueur m >= n * log_2(10)
      x = (0...m).map { 2 }         # initialiser le vecteur avec des valeurs 2
      nines= 0;                     # nombre des chiffres 9 qui attendent en queue
      predigit= 0;                  # le chiffre précédent la queue des chiffres 9

      n.times do                    # boucle pour produire n chiffres de pi
        q = 0;                      # retenue de la normalisation
          (m-1).downto(0) do |i|    # boucle parcourant le vecteur en inverse
          a = 10*x[i] + q*(i+1);    # multiplier par 10 et ajouter la retenue
          x[i] = a % (2*i+1);       # stocker le reste (valeur normalisée)
          q    = a / (2*i+1);       # garder la retenue pour la place i-1
        end
      
        x[0] = q%10;                # x[0] est la place de poids entier
        q  /= 10;                   # q est alors le chiffre à afficher
      
        case q                      # Il faut distinguer plusieurs cas...
        when 9 then                 # Un chiffre "9" peut encore changer
          nines += 1;               # à cause d'une future propagation de retenue.
        when 10 then                # Un chiffre "10" produit une telle retenue.
          res+=(predigit+1).to_s    # On concactène les chiffres dont
          predigit= 0;              # la valeur ne peut plus changer.
          nines.times { res+="0" }
          nines = 0
        else                        # Tout autre chiffre ne peut pas provoquer 
          res+=predigit.to_s        # de propagation de retenue, donc on ajoute
          predigit = q;             # maintenant les chiffres dont on est sûr.
          nines.times { res+="9" }
          nines = 0
        end
      end
                        
      res+=predigit.to_s            # on contactène le dernier chiffre en stock
    end

    # Translation of Jeremy Gibbons' Haskell solution
    # Infinite digit generation of PI  
    # Usage: jeremy_gibbons {|digit| print digit; $stdout.flush}
    def jeremy_gibbons
      q, r, t, k, n, l = 1, 0, 1, 1, 3, 3
      dot = nil
      loop do
        if 4*q+r-t < n*t
          yield n
          if dot.nil? 
            yield '.'
            dot = '.'
          end
          nr = 10*(r-n*t)
          n = ((10*(3*q+r)) / t) - 10*n
          q *= 10
          r = nr
        else
          nr = (2*q+r) * l
          nn = (q*(7*k+2)+r*l) / (t*l)
          q *= k
          t *= l
          l += 2
          k += 1
          n = nn
          r = nr
        end
      end
    end
   end
end