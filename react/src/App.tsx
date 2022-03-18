import {useState, useEffect} from 'react'

interface TestData {
    id: String
    test_id: String
}

export const App = () => {

    // REST APIの結果を持つstate
    const [result, setResult] = useState<TestData>({id: "",test_id: ""})

    //
    useEffect(() => {
        fetch('https://testapi.build-automation.de/dynamodb?id=1001', {method: 'GET'})
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

    return (
        <>
            <h1>React App</h1>
            <div>
                <h2>REST APIの結果</h2>
                <ul>
                    <li>id :{result.id}</li>
                    <li>test_id: {result.test_id}</li>
                </ul>
            </div>
        </>
    )
}