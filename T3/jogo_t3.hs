vence :: String -> String -> Bool
vence "Pedra" "Tesoura" = True 
vence "Pedra" "Agua" = True

vence "Tesoura" "Papel" = True
vence "Tesoura" "Agua" = True

vence "Papel" "Pedra" = True
vence "Papel" "Agua" = True

vence "Fogo" "Pedra" = True
vence "Fogo" "Papel" = True
vence "Fogo" "Tesoura" = True

vence "Agua" "Fogo" = True

vence _ _ = False


resultado :: String -> String -> String
resultado jogador maquina
    | jogador == maquina = "Empate!"
    | vence jogador maquina = "Voce venceu!"
    | otherwise = "Voce perdeu!"


resultadoDeus :: String -> String
resultadoDeus entrada
    | entrada == "Tesoura" = resultado entrada "Fogo"
    | entrada == "Pedra"   = resultado entrada "Fogo"
    | entrada == "Papel"   = resultado entrada "Fogo"
    | entrada == "Fogo"    = resultado entrada "Agua"
    | otherwise            = resultado entrada "Pedra"


resultadoTonto :: String -> String
resultadoTonto entrada
    | entrada == "Fogo" = resultado entrada "Pedra"
    | entrada == "Agua" = resultado entrada "Fogo"
    | otherwise         = resultado entrada "Agua"


jogar modo = do
    putStrLn "Escolha sua jogada:"
    putStrLn "1 - Pedra"
    putStrLn "2 - Papel"
    putStrLn "3 - Tesoura"
    putStrLn "4 - Agua"
    putStrLn "5 - Fogo"

    entrada <- getLine
    jogada <- case entrada of
        "1" -> return ("Pedra")
        "2" -> return ("Papel")
        "3" -> return ("Tesoura")
        "4" -> return ("Agua")
        "5" -> return ("Fogo")

    resultado <- case modo of
        "1" -> return (resultadoDeus jogada)
        "2" -> return (resultadoTonto jogada)

    putStrLn (resultado)

main :: IO ()
main = do
    putStrLn "Escolha um modo"
    putStrLn "1 - Deus"
    putStrLn "2 - Tonto"
    modo <- getLine
    jogar modo
