const monsters = {
  Emby: {
    position: {
      x: 315,
      y: 330
    },
    image: {
      src: '../img/embySprite.png'
    },
    frames: {
      max: 4,
      hold: 30
    },
    animate: true,
    name: 'Emby',
    attacks: [attacks.Tackle, attacks.Fireball, attacks.ManaPotion, attacks.HealthPotion]
  },
  Draggle: {
    position: {
      x: 770,
      y: 150
    },
    image: {
      src: '../img/draggleSprite.png'
    },
    frames: {
      max: 4,
      hold: 30
    },
    animate: true,
    isEnemy: true,
    name: 'Draggle',
    attacks: [attacks.Tackle, attacks.Slimeball]
  }
}
