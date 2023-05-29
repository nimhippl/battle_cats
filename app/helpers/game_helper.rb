require 'rpgAPI'

module GameHelper

  include Game

  class Kitty < SmartEntity

    attr_accessor :img_src

    def initialize(name, team, strength, agility, intelligence, weapon)
      super(name, team, strength.to_i, agility.to_i, intelligence.to_i, weapon)
    end

    def take_turn1(move_id, target)
      take_turn
      if move_id == 0
        attack(target)
      else
        use_skill(@skill_list[move_id - 1], target)
      end
    end

    def get_formatted_hp
      white_hearts =(current_hp / maximum_hp * 10).round
      '♥' * [white_hearts, 0].max +  '♡' * [10 - white_hearts, 10].min +  format("%5d/%5d\n", current_hp, maximum_hp)
    end

  end


  def create_Voyaka

    #Voyaka
    #str: 30
    #agi: 20
    #int: 12

    sword = Game::Weapon.new('Sword', 1.1)
    st_weak = Game::Status.new(4,
                               nil,
                               Proc.new { |owner, caster| owner.armor -= 10; caster.armor += 10; },
                               Proc.new { |owner, caster| owner.armor += 10; caster.armor -= 10; },
                               nil,
                               nil,
                               nil
    )
    #skills{
    #WAR CRY: Боевой клич!!! Кавабанга!!! Вы повышаете свою броню и понижете броню врага
    warcry = Game::BaseSkill.new('Warcry', Set[:debuff], 20, Proc.new { |user, target| target.add_status(st_weak, user) })
    #SWORD SLASH: Вы размахиваете мечём. Наносите физический урон
    sword_slash = Game::BaseSkill.new('Sword slash', Set[:damaging], 50, Proc.new { |user, target| target.take_damage(user.attack_damage * 1.7, :physical, user) })
    #ARMOR PIERCING: Вы наносите точный удар, проходящий сквозь броню врага. Враг получает чистый урон
    armor_piercing = Game::BaseSkill.new('Armor pierce', Set[:damaging], 30, Proc.new { |user, target| target.take_damage(user.attack_damage * 1.0, :pure, user) })
    #}

    voyaka = Kitty.new("Voyaka", :team1, 30, 20, 12, sword)
    voyaka.learn_skills(warcry, sword_slash, armor_piercing)
    voyaka.img_src =  'voyaka.jpg'
    voyaka
  end

  def create_Kogtic

    #Kogtic
    #str: 20
    #agi: 50
    #int: 9

    claws = Game::Weapon.new('Claws', 1.0)
    st_bleed = Game::Status.new(3,
                                Proc.new { |owner, cur, caster| owner.take_damage(caster.attack_damage * 0.7, :physical, caster) },
                                nil,
                                nil,
                                nil,
                                nil,
                                nil
    )
    st_retreat = Game::Status.new(1,
                                  nil,
                                  Proc.new { |owner, caster| owner.armor += 40 },
                                  Proc.new { |owner, caster| owner.armor -= 40 },
                                  nil,
                                  nil,
                                  nil
    )
    #skills{
    #TEAR: Вы пытаетесь разорвать врага когтями. Вы наноситe физ урон и накладываетe кровотечение(стакается)
    tear = Game::BaseSkill.new('Tear', Set[:damaging], 50, Proc.new { |user, target| target.add_status(st_bleed, user); target.take_damage(user.attack_damage * 1.2, :physical, user) })
    #RETREAT: вы готовитесь к атаке... повышает броню на один ход и восстанавливает 50 маны
    retreat = Game::BaseSkill.new('Retreat', Set[:buff], 0, Proc.new { |user, target| user.add_status(st_retreat, user); user.mana += 50 })
    #ASSASINATION: Вы готовите финальный удар. Наносите огромный физический урон в зависимости от вашей скорости и недостающего хп врага
    assasination = Game::BaseSkill.new('Assasination', Set[:damaging], 100, Proc.new { |user, target| target.take_damage(60 + (target.maximum_hp - target.current_hp) * user.speed * 0.01, :physical, user) })
    #}

    kogtic = Kitty.new("Kogtic", :team2, 20, 50, 9, claws)
    kogtic.learn_skills(tear, retreat, assasination)
    kogtic.img_src =  'kogtic.jpg'
    kogtic
  end

  def create_Mewg

    #Mewg
    #str: 15
    #agi: 15
    #int: 41

    staff = Game::Weapon.new('Staff', 0.2)
    st_frosted = Game::Status.new(1,
                                  nil,
                                  Proc.new { |owner, caster| owner.speed /= 2 },
                                  Proc.new { |owner, caster| owner.speed *= 2 },
                                  nil,
                                  nil,
                                  nil
    )
    #skills{
    #FIREBALL: наносит магический урон
    fireball = Game::BaseSkill.new('Fireball', Set[:damaging], 30, Proc.new { |user, target| target.take_damage(user.ability_power * 1.0, :magic, user) })
    #ICE SHARDS: наносит немного магического урона и замедляет в 2 раза врага
    ice_shards = Game::BaseSkill.new('Ice shards', Set[:damaging, :debuff], 50, Proc.new { |user, target| target.take_damage(user.ability_power * 0.7, :magic, user); target.add_status(st_frosted, user) })
    #EMP: выжигает половину маны врага, восстанавливает её вам, наносит врагу урон в зависимости от выжженой маны
    emp = Game::BaseSkill.new('EMP', Set[:damaging], 0, Proc.new { |user, target| target.take_damage(target.mana * 0.5, :magic, user); target.mana -= target.mana * 0.5; user.mana += target.mana * 0.5; })
    #}

    mewg = Kitty.new("Mewg", :team3, 15, 15, 41, staff)
    mewg.learn_skills(fireball, ice_shards, emp)
    mewg.img_src =  'mewg.jpg'
    mewg
  end

  def create_Samewrai

    #Samewrai
    #str: 20
    #agi: 55
    #int: 8

    katana = Game::Weapon.new('Katana', 1.5)
    #skills{
    #STEEL TEMPEST: вы наносите чёткий удар катаной, чувтвуете стиль, что придаёт вам силы. Каждая такая атака увеличивает силу атаки на 1
    steel_tempest = Game::BaseSkill.new('Steel Tempest', Set[:damaging], 0, Proc.new { |user, target| target.take_damage(user.attack_damage * 1.0, :physical, user); user.attack_damage += 1 })
    #QUICK DASH: вы делаете резкий рывой через врага, нанося ему урон, взависимости от вашей скорости. Каждая такая атака увеличивает броню на 1
    quick_dash = Game::BaseSkill.new('Quick dash', Set[:damaging], 0, Proc.new { |user, target| target.take_damage(user.speed * 0.3, :physical, user); user.armor += 1 })
    #}

    samewrai = Kitty.new("Samewrai", :team4, 20, 55, 8, katana)
    samewrai.learn_skills(steel_tempest, quick_dash)
    samewrai.img_src =  'samewrai.jpg'
    samewrai
  end

  def create_Mewlitvenik
    0
    #Mewlitvenik
    #str: 30
    #agi: 20
    #int: 35

    #skills{
    #PRAYER: вы молитесь патриарху Кирилу, за что тот благословляет вас. Вы восстанавливаете хп и ману
    prayer = Game::BaseSkill.new('Prayer', Set[:damaging, :healing], 0, Proc.new { |user, target| user.heal(user.ability_power); user.mana += user.ability_power })
    #HOLY LIGHT: вы призываете священный свет, что озарит вас и ваших врагов. Вы наносите урон врагам, и восстанавливаете немного здоровья
    holy_light = Game::BaseSkill.new('Holy light', Set[:damaging, :healing], 50, Proc.new { |user, target| target.take_damage(user.ability_power * 0.4, :magic, user); user.heal(user.ability_power * 0.4) })
    #EPITAPHY: ПРАВОСЛАВНЫЕ ВПЕРЁД ПАТРИАРХ КИРИЛЛ ИДЁТ ЦАРСТВО БОЖИЕ ПРИДЁТ. Вы поёте прощальную песню. Наносит огромный урон врагу, в зависимости от недостающего здоровья
    epitaphy = Game::BaseSkill.new('Epitaphy', Set[:damaging], 100, Proc.new { |user, target| target.take_damage(60 + (target.maximum_hp - target.current_hp) * user.ability_power * 0.015, :magic, user); })
    #}
    staff = Game::Weapon.new('Staff', 0.2)

    mewlitvenik = Kitty.new("Mewlitvenik", :team5, 30, 20, 35, staff)
    mewlitvenik.learn_skills(prayer, holy_light, epitaphy)
    mewlitvenik.img_src =  'mewlitvenik.jpg'
    mewlitvenik
  end

  def create_Bulk

    #Bulk
    #str: 20
    #agi: 20
    #int: 20

    water_paws = Game::Weapon.new('Water paws', 1.0)
    form_attack = Game::Status.new(2,
                                   nil,
                                   Proc.new { |owner, caster| owner.speed += 20; owner.attack_damage += 20; },
                                   Proc.new { |owner, caster| owner.speed -= 20; owner.attack_damage -= 20; },
                                   Proc.new { |owner, target, caster| target.take_damage(owner.attack_damage * 0.1, :magic, owner) },
                                   nil,
                                   Proc.new { |owner, caster| owner.speed -= 20; owner.attack_damage -= 20; }
    )
    form_defence = Game::Status.new(2,
                                    nil,
                                    Proc.new { |owner, caster| owner.armor += 20; owner.magic_resist += 20; },
                                    Proc.new { |owner, caster| owner.armor -= 20; owner.magic_resist -= 20; },
                                    Proc.new { |owner, target, caster| owner.heal(target.attack_damage * 0.4) },
                                    Proc.new { |owner, dealer, caster| owner.heal(dealer.attack_damage * 0.4) },
                                    Proc.new { |owner, caster| owner.armor -= 20; owner.magic_resist -= 20; }
    )
    form_magic = Game::Status.new(2,
                                  nil,
                                  Proc.new { |owner, caster| owner.ability_power += 20; },
                                  Proc.new { |owner, caster| owner.ability_power -= 20; },
                                  Proc.new { |owner, target, caster| target.take_damage(owner.ability_power * 0.5, :magic, owner) },
                                  Proc.new { |owner, dealer, caster| dealer.take_damage(dealer.attack_damage * owner.ability_power * 0.01, :magic, owner) },
                                  Proc.new { |owner, caster| owner.ability_power -= 20; }
    )
    #skills{
    #ПЕРСОНАЖ ПИЗДЕЦ, БАЛАНС ХЗ, НО ИНТЕРЕСНЫЙ
    #ATTACK FORM: вы принимаете атакующую форму. Сила атаки и скорость увеличины. Автоатаки дополнительно наносят немного магического урона
    attack_form = Game::BaseSkill.new('Attack form', Set[:buff], 0, Proc.new { |user, target| user.add_status(form_attack, user); user.delete_status(form_defence); user.delete_status(form_magic) })
    #DEFENCE FORM: вы принимаете защитную форму. Броня и сопротивление магии увеличины. Вы восстанавливаете здоровье когда вас бьёт враг, и когда вы бьёте врага
    defence_form = Game::BaseSkill.new('Defence form', Set[:buff], 0, Proc.new { |user, target| user.add_status(form_defence, user); user.delete_status(form_attack); user.delete_status(form_magic) })
    #MAGIC FORM: вы принимаете ИСЛАМ (магическую форму). Сила умений увеличина. Ваши атаки дополнительно наносят немало магического урона. Когда вас бьют, вы наносите в ответ магический урон
    magic_form = Game::BaseSkill.new('Magic form', Set[:buff], 0, Proc.new { |user, target| user.add_status(form_magic, user); user.delete_status(form_defence); user.delete_status(form_attack) })
    #}

    bulk = Kitty.new("Bulk", :team6, 20, 20, 20, water_paws)
    bulk.learn_skills(attack_form, defence_form, magic_form)
    bulk.img_src = 'bulk.jpg'

    bulk
  end

end
