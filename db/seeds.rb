# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
    Admin.create({
                    email: 'cooker_bj@hotmail.com',
                    password: 'legend8898',
                    name: "administrator" ,
                    roles: [1,2,4,8]
                 })
    begin
    root=Location.create({name: '北京'})
      city=root.children.create({name: '北京'})
        ['东城','西城','海淀','朝阳','丰台','通州','石景山','门头沟','昌平','延庆','平谷','密云','怀柔','顺义','大兴'].each do |district|
        city.children.create({name: district})
        end
    end

    category={'语言'=>['英语','日语','法语','德语','俄语'],'音乐'=>['钢琴','小提琴','吉他','声乐','其它'],'书画'=>['绘画','书法'],'体育'=>['游泳','轮滑','羽毛球','舞蹈','围棋','其它']}
    category.each do |key,value|
       root=Category.create({name: key})
       value.each do |item|
         root.children.create({name: item})
       end
    end
    User.create({
        email: 'system@uesku.com',
        real_name: '系统通知',
        nickname: '系统通知',
        password: Devise.friendly_token[0,20]
        })