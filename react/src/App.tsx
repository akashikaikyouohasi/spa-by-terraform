import {useState, useEffect} from 'react'
import { useAuth0 } from '@auth0/auth0-react'

interface TestData {
    id: String
    test_id: String
}

export const App = () => {
    // Auth0のログインに関わる変数
    const { isAuthenticated, loginWithRedirect, logout } = useAuth0();
    
    // REST APIの結果を持つstate
    const [result, setResult] = useState<TestData>({id: "",test_id: ""})

    // API GatewayのREST APIを呼び出して結果をStateの格納する。
    useEffect(() => {
        fetch('https://testapi.build-automation.de/dynamodb?id=1001', {method: 'GET', mode: 'cors'})
        .then(res => {return res.json()})
        .then(data => {
            console.log(data)
            const testdata: TestData = { id: data.id, test_id: data.test_id}
            setResult(testdata)
        })
        .catch((e) => {
            console.log(e)  //エラーをキャッチし表示     
        })  
    },[]) //第二引数は依存配列。省略すると無限ループ。空配列で初回レンダリング時のみ実行

    // REST APIを呼び出した結果を表示すうｒ。
    return (
        <>
            <h1>React App</h1>
            <div>
                <h2>REST APIの結果</h2>
                <ul>
                    { !isAuthenticated ? (
                        <button onClick={loginWithRedirect}>Log in</button>
                    ) : (
                        <button
                            onClick={() => {
                                logout({ returnTo: window.location.origin})
                            }}>
                                Log out
                            </button>
                    )}
                    <li>id :{result.id}</li>
                    <li>test_id: {result.test_id}</li>
                </ul>
            </div>
        </>
    )
}