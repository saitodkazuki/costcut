# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Tag.create(:name => '朝飯')
Tag.create(:name => '昼飯')
Tag.create(:name => '夜飯')
Tag.create(:name => '飲み物')
Tag.create(:name => 'お菓子')
Tag.create(:name => 'カフェ')
Tag.create(:name => '勉強')
Tag.create(:name => 'プレゼント')
Tag.create(:name => '電車')
Tag.create(:name => '文房具')
Tag.create(:name => '映画')
Tag.create(:name => '化粧品')
Tag.create(:name => '衣服')
Tag.create(:name => '漫画')
Tag.create(:name => '音楽')
Tag.create(:name => '美容院')

Expense.create(:paid_at => '2017-01-30', :amount => 3000, :tag => '夜飯')
Expense.create(:paid_at => '2017-01-29', :amount => 2000, :tag => '昼飯')
Expense.create(:paid_at => '2017-01-28', :amount => 3000, :tag => '夜飯')
Expense.create(:paid_at => '2017-01-27', :amount => 2000, :tag => '昼飯')
Expense.create(:paid_at => '2017-01-26', :amount => 3000, :tag => '夜飯')
Expense.create(:paid_at => '2017-01-25', :amount => 2000, :tag => '昼飯')
Expense.create(:paid_at => '2017-01-24', :amount => 3000, :tag => '夜飯')
Expense.create(:paid_at => '2017-01-23', :amount => 2000, :tag => '朝飯')
Expense.create(:paid_at => '2017-01-22', :amount => 3000, :tag => '昼飯')
Expense.create(:paid_at => '2017-01-21', :amount => 4000, :tag => '夜飯')
Expense.create(:paid_at => '2017-01-20', :amount => 5000, :tag => '朝飯')
Expense.create(:paid_at => '2017-01-19', :amount => 2000, :tag => '昼飯')
Expense.create(:paid_at => '2017-01-18', :amount => 3000, :tag => '夜飯')

Admin.create(:email => 'saito.d.kazuki@gmail.com', :created_at => '2017-01-24 08:33:53', :updated_at => '2017-01-24 09:07:55')
