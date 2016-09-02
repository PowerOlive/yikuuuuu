username='13800000000'
password='000000'

do_login() {
    t=$((`date +%s`*1000+`date +%-N`/1000000))
    data='passport='$username'&password='$password'&captcha=&remember=1&callback=logincallback_'$t'&from=http%3A%2F%2Flogin.youku.com%2F@@@@&wintype=page'
    result=$(curl -A "User-Agent: Mozilla/4.0" -c youku.cookie --location --data $data https://login.youku.com/user/login_submit/ 2>/dev/null)
    echo "$result" |grep -q "len-2"
    if [ $? -eq 0 ]; then
        echo 0
        return
    fi
    echo 1
    return
}

do_speed_up() {
    result=$(curl -A "User-Agent: Mozilla/4.0" -X POST -b youku.cookie -d '' 'http://vip.youku.com/?c=ajax&a=ajax_do_speed_up' 2>/dev/null)
    echo $result
}

result=`do_speed_up`

echo "$result" |grep -q "20011"
if [ $? -eq 0 ]; then
    result=`do_login`
    if [ x"$result" == x"0" ]; then
        echo `date +%Y-%m-%d-%H:%M:%S`" 登录成功"
        echo `date +%Y-%m-%d-%H:%M:%S`" 登录成功" > /tmp/yiku.status
    else
        echo `date +%Y-%m-%d-%H:%M:%S`" 登录失败"
        echo `date +%Y-%m-%d-%H:%M:%S`" 登录失败" > /tmp/yiku.status
        exit
    fi
else
    echo `date +%Y-%m-%d-%H:%M:%S`" 已经登录"
fi

result=`do_speed_up`
echo "$result" |grep -q "20021"
if [ $? -eq 0 ]; then
    echo `date +%Y-%m-%d-%H:%M:%S`" 已经提速"
fi

echo "$result" |grep -q "20011"
if [ $? -eq 0 ]; then
    echo `date +%Y-%m-%d-%H:%M:%S`" 登录喵喵喵?"
    echo `date +%Y-%m-%d-%H:%M:%S`" 登录喵喵喵?" > /tmp/yiku.status
fi

echo "$result" |grep -q "20000"
if [ $? -eq 0 ]; then
    echo `date +%Y-%m-%d-%H:%M:%S`" 提速成功"
    echo `date +%Y-%m-%d-%H:%M:%S`" 提速成功" > /tmp/yiku.status
fi