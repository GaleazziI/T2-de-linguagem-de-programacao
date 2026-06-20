import System.Random (randomRIO)

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

pickRandom :: [String] -> IO String
pickRandom xs = do
    idx <- randomRIO (0, length xs - 1)
    return (xs !! idx)

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

resultadoNormal :: String -> IO String
resultadoNormal entrada = do
    maquina <- pickRandom ["Pedra", "Papel", "Tesoura", "Fogo", "Agua"]
    return (resultado entrada maquina)

jogar :: String -> IO ()
jogar modo = do
    putStrLn "Escolha sua jogada:"
    putStrLn "1 - Pedra"
    putStrLn "2 - Papel"
    putStrLn "3 - Tesoura"
    putStrLn "4 - Agua"
    putStrLn "5 - Fogo"

    entrada <- getLine

    let jogada = case entrada of
            "1" -> "Pedra"
            "2" -> "Papel"
            "3" -> "Tesoura"
            "4" -> "Agua"
            "5" -> "Fogo"
            _   -> "Pedra"

    resultadoFinal <- case modo of
        "1" -> return (resultadoDeus jogada)
        "2" -> return (resultadoTonto jogada)
        "3" -> resultadoNormal jogada
        _   -> return "Modo invalido"

    putStrLn resultadoFinal
    
    putStrLn "\n Jogar Novamente? (s/n)"
    resp <- getLine
    
    if resp == "s"
        then jogar modo
        else putStrLn "Fim de Jogo!"

main :: IO ()
main = do
    putStrLn "Escolha um modo"
    putStrLn "1 - Deus"
    putStrLn "2 - Tonto"
    putStrLn "3 - Normal"

    modo <- getLine
    jogar modo
