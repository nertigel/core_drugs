return {
    ['fertilizer'] = {
        label = 'Fertilizer',
        weight = 1000,
        stack = true,
        close = true,
        description = "Helps plants grow"
    },
    ['watering_can'] = {
        label = 'Watering Can',
        weight = 500,
        stack = true,
        close = true,
        description = "Full of water, can be used to water plants"
    },
    ['scale'] = {
        label = 'Scale',
        weight = 100,
        stack = true,
        close = true,
        description = "Used to scale stuff for specific weight"
    },

    ['weed_bk'] = {
        label = 'Bubba Kush',
        weight = 1,
        client = {
            status = { stress = -250000 },
            anim = 'smoke_joint',
            prop = 'joint',
            usetime = 10000,
            export = 'core_drugs._n_use_weed_bk'
        },
        stack = true,
        description = "Sativa | May cause dry mouth"
    },

    ['weed_bk_seed'] = {
        label = 'Bubba Kush',
        weight = 5,
        client = {
            export = 'core_drugs._n_plant_weed_bk_seed'
        },
        stack = true,
        close = true,
        description = "15-22% THC | Sativa"
    },

    ['weed_lh'] = {
        label = 'Lemon Haze',
        weight = 1,
        client = {
            status = { stress = -100000 },
            anim = 'smoke_joint',
            prop = 'joint',
            usetime = 10000,
            export = 'core_drugs._n_use_weed_lh'
        },
        stack = true,
        description = "Sativa | May cause dry mouth & munchies"
    },

    ['weed_lh_seed'] = {
        label = 'Lemon Haze',
        weight = 5,
        client = {
            export = 'core_drugs._n_plant_weed_lh_seed'
        },
        stack = true,
        close = true,
        description = "15-20% THC | Sativa"
    },

    ['weed_wc'] = {
        label = 'Wedding Cake',
        weight = 1,
        client = {
            status = { stress = -150000 },
            anim = 'smoke_joint',
            prop = 'joint',
            usetime = 10000,
            export = 'core_drugs._n_use_weed_wc'
        },
        stack = true,
        description = "Hybrid | May cause munchies"
    },

    ['weed_wc_seed'] = {
        label = 'Wedding Cake',
        weight = 5,
        client = {
            export = 'core_drugs._n_plant_weed_wc_seed'
        },
        stack = true,
        close = true,
        description = "20-23% THC | Hybrid"
    },

    ['weed_ww'] = {
        label = 'White Widow',
        weight = 1,
        client = {
            status = { stress = -200000 },
            anim = 'smoke_joint',
            prop = 'joint',
            usetime = 10000,
            export = 'core_drugs._n_use_weed_ww'
        },
        stack = true,
        description = "Hybrid | May cause munchies"
    },

    ['weed_ww_seed'] = {
        label = 'White Widow',
        weight = 5,
        client = {
            export = 'core_drugs._n_plant_weed_ww_seed'
        },
        stack = true,
        close = true,
        description = "16-25% THC | Hybrid"
    },

    ['weed_mc'] = {
        label = 'Miracle Cookies',
        weight = 1,
        client = {
            status = { stress = -300000 },
            anim = 'smoke_joint',
            prop = 'joint',
            usetime = 10000,
            export = 'core_drugs._n_use_weed_mc'
        },
        stack = true,
        description = "Indica | May cause dry mouth & munchies"
    },

    ['weed_mc_seed'] = {
        label = 'Miracle Cookies',
        weight = 5,
        client = {
            export = 'core_drugs._n_plant_weed_mc_seed'
        },
        stack = true,
        close = true,
        description = "23-25% THC | Indica"
    },

    ['weed_hk'] = {
        label = 'Hindu Kush',
        weight = 1,
        client = {
            status = { stress = -350000 },
            anim = 'smoke_joint',
            prop = 'joint',
            usetime = 10000,
            export = 'core_drugs._n_use_weed_hk'
        },
        stack = true,
        description = "Indica | May cause munchies"
    },

    ['weed_hk_seed'] = {
        label = 'Hindu Kush',
        weight = 5,
        client = {
            export = 'core_drugs._n_plant_weed_hk_seed'
        },
        stack = true,
        close = true,
        description = "18-25% THC | Indica"
    },

    ['weed_do'] = {
        label = 'Do Si Dos',
        weight = 1,
        client = {
            status = { stress = -350000 },
            anim = 'smoke_joint',
            prop = 'joint',
            usetime = 10000,
            export = 'core_drugs._n_use_weed_do'
        },
        stack = true,
        description = "Indica | May cause dry mouth"
    },

    ['weed_do_seed'] = {
        label = 'Do Si Dos',
        weight = 5,
        client = {
            export = 'core_drugs._n_plant_weed_do_seed'
        },
        stack = true,
        close = true,
        description = "20-27% THC | Indica"
    },

    ['weed_gg'] = {
        label = 'Gorilla Glue 4',
        weight = 1,
        client = {
            status = { stress = -300000 },
            anim = 'smoke_joint',
            prop = 'joint',
            usetime = 10000,
            export = 'core_drugs._n_use_weed_gg'
        },
        stack = true,
        description = "Indica | May cause dry mouth & munchies"
    },

    ['weed_gg_seed'] = {
        label = 'Gorilla Glue 4',
        weight = 5,
        client = {
            export = 'core_drugs._n_plant_weed_gg_seed'
        },
        stack = true,
        close = true,
        description = "22-27% THC | Indica"
    },

    ['weed_gmo'] = {
        label = 'GMO Cookies',
        weight = 1,
        client = {
            status = { stress = -200000 },
            anim = 'smoke_joint',
            prop = 'joint',
            usetime = 10000,
            export = 'core_drugs._n_use_weed_gmo'
        },
        stack = true,
        description = "Indica | May cause munchies"
    },

    ['weed_gmo_seed'] = {
        label = 'GMO Cookies',
        weight = 5,
        client = {
            export = 'core_drugs._n_plant_weed_gmo_seed'
        },
        stack = true,
        close = true,
        description = "18-28% THC | Indica"
    },
}