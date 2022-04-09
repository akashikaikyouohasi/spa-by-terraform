import { useAuth0  } from "@auth0/auth0-react"

export const Profile = () => {
    
    const { user, isAuthenticated, isLoading } = useAuth0()

    // 認証され、ユーザー情報が取得できた場合は表示
    if(isAuthenticated && user != undefined) {
        return (
            <>
                <div>
                    <ul>
                        <li><p>プロフィール画像</p><img src={user.picture} alt={user.name} /></li>
                        <li><p>ユーザー名:{user.name}</p></li>
                    </ul>
                </div>
            </>
        )
    }

    if (isLoading) {
        return <div>Loading ...</div>
    }

    // 最後までたどりついてしまった場合は何も表示しない。
    return (
    <>
        <div>ログイン後にプロフィール表示</div>
    </>
    )
}