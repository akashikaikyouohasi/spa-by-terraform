import {useState, useEffect} from 'react'
import { useAuth0 } from '@auth0/auth0-react'
import { Profile } from './Profile'

interface TestData {
    id: String
    test_id: String
}

export const App = () => {
    // Auth0のログインに関わる変数
    const { isAuthenticated, loginWithRedirect, logout, getAccessTokenSilently } = useAuth0();

    // REST APIの結果を持つstate
    const [result, setResult] = useState<TestData>({id: "(認証待ち)",test_id: "(認証待ち)"})

    // API GatewayのREST APIを呼び出して結果をStateの格納する。
    useEffect(() => {
        const getDynamoDBdata = async () => {
            try {
                console.log("アクセストークン取得")
                const accessToken = await getAccessTokenSilently({
                    audience: "https://testapi.build-automation.de", // Auth0のAPIsのIdentifierを設定すること
                    scope: "read:current_user update:current_user_metadata",
                })

                console.log("アクセストークン取得済み")

                const dynamoDBdataByUrl = 'https://testapi.build-automation.de/dynamodb?id=1001'

                // REST APIを叩いて結果を取得
                const dataResponse = await fetch(dynamoDBdataByUrl, {
                    headers: {
                        Authorization: `Bearer ${accessToken}`,
                    },
                    method: 'GET',
                    mode: 'cors'
                })
                .then(res => {return res.json()})

                console.log("データ取得済み")

                const testdata: TestData = { id: dataResponse.id, test_id: dataResponse.test_id }
                setResult(testdata)
            } catch (e: any) {
                console.log(e.message);
            }
        }
        getDynamoDBdata()   
    },[getAccessTokenSilently]) //第二引数は依存配列。省略すると無限ループ。空配列で初回レンダリング時のみ実行

    // REST APIを呼び出した結果を表示する。
    return (
        <>
            <div>
                <h2>Auth0ログイン</h2>
                { !isAuthenticated ? (
                    <>
                        <div>Auth0にログイン後、REST APIの結果が表示されます。</div>
                        <button onClick={loginWithRedirect}>Auth0 Log in</button>
                    </>
                ) : (
                    <>
                        <div>ログイン状況：ログイン済み</div>
                        <button
                            onClick={() => {
                                logout({ returnTo: window.location.origin})
                            }}>
                                Auth0 Log out
                        </button>
                        <h3>ログインユーザー情報</h3>
                        <Profile />
                    </>
                )}
                <h2>REST APIの結果を表示</h2>
                <ul>  
                    <li>id :{result.id}</li>
                    <li>test_id: {result.test_id}</li>
                </ul>
            </div>
        </>
    )
}