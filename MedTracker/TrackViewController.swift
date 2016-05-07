//
//  TrackViewController.swift
//  MedTracker
//
//  Created by Matt Deuschle on 5/6/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController {

    @IBOutlet var morningSwitch: UISwitch!
    @IBOutlet var afternoonSwtich: UISwitch!
    @IBOutlet var eveninigSwitch: UISwitch!
    @IBOutlet var bedtimeSwtich: UISwitch!
    @IBOutlet var nineSwitch: UISwitch!
    @IBOutlet var twoSwitch: UISwitch!
    @IBOutlet var sevenSwtich: UISwitch!
    @IBOutlet var elevenSwtich: UISwitch!

    var storedDate = ""
    var currentDate = ""

    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let daterecoreded = defaults.stringForKey("storeddate") {
            storedDate = daterecoreded
        }

        currentDate = getDate()

        if currentDate == storedDate {

            if let _ = defaults.stringForKey("takenmorning") {
                morningSwitch.setOn(true, animated: true)
            }
            if let _ = defaults.stringForKey("takenafternoon") {
                afternoonSwtich.setOn(true, animated: true)
            }
            if let _ = defaults.stringForKey("takenevening") {
                eveninigSwitch.setOn(true, animated: true)
            }
            if let _ = defaults.stringForKey("takenbedtime") {
                bedtimeSwtich.setOn(true, animated: true)
            }
        } else if currentDate != storedDate {

            defaults.removeObjectForKey("takenmorning")
            defaults.removeObjectForKey("takenafternoon")
            defaults.removeObjectForKey("takenevening")
            defaults.removeObjectForKey("takenbedtime")

            morningSwitch.setOn(false, animated: true)
            afternoonSwtich.setOn(false, animated: true)
            eveninigSwitch.setOn(false, animated: true)
            bedtimeSwtich.setOn(false, animated: true)
        }

        // for local notifications

        if let _ = defaults.stringForKey("remindermorning") {
            nineSwitch.setOn(true, animated: true)
        }

        if let _ = defaults.stringForKey("reminderafternoon") {
            twoSwitch.setOn(true, animated: true)
        }

        if let _ = defaults.stringForKey("reminderevening") {
            sevenSwtich.setOn(true, animated: true)
        }

        if let _ = defaults.stringForKey("reminderbedtime") {
            elevenSwtich.setOn(true, animated: true)
        }
    }

    func getDate() -> String {

        let date = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .NoStyle)
        return date
    }

    @IBAction func morningTapped(sender: UISwitch) {

        storedDate = getDate()

        if morningSwitch.on {

            defaults.setObject(storedDate, forKey: "storeddate")
            defaults.setObject(morningSwitch.on, forKey: "takenmorning")
            morningSwitch.setOn(true, animated: true)
        } else {

            if let _ = defaults.stringForKey("takenmorning") {
                morningSwitch.setOn(false, animated: true)
                defaults.removeObjectForKey("takenmorning")
            }
        }
    }

    @IBAction func afternoonTapped(sender: UISwitch) {

        storedDate = getDate()

        if afternoonSwtich.on {

            defaults.setObject(storedDate, forKey: "storeddate")
            defaults.setObject(afternoonSwtich.on, forKey: "takenafternoon")
            afternoonSwtich.setOn(true, animated: true)
        } else {

            if let _ = defaults.stringForKey("takenafternoon") {
                afternoonSwtich.setOn(false, animated: true)
                defaults.removeObjectForKey("takenafternoon")
            }
        }
    }

    @IBAction func eveningTapped(sender: UISwitch) {

        storedDate = getDate()

        if eveninigSwitch.on {

            defaults.setObject(storedDate, forKey: "storeddate")
            defaults.setObject(eveninigSwitch.on, forKey: "takenevening")
            eveninigSwitch.setOn(true, animated: true)
        } else {

            if let _ = defaults.stringForKey("takenevening") {
                eveninigSwitch.setOn(false, animated: true)
                defaults.removeObjectForKey("takenevening")
            }
        }
    }

    @IBAction func bedtimeTapped(sender: UISwitch) {

        storedDate = getDate()

        if bedtimeSwtich.on {

            defaults.setObject(storedDate, forKey: "storeddate")
            defaults.setObject(bedtimeSwtich.on, forKey: "takenbedtime")
            bedtimeSwtich.setOn(true, animated: true)
        } else {

            if let _ = defaults.stringForKey("takenbedtime") {
                bedtimeSwtich.setOn(false, animated: true)
                defaults.removeObjectForKey("takenbedtime")
            }
        }
    }

    var morningNotification = UILocalNotification()
    @IBAction func nineTapped(sender: UISwitch) {

        if nineSwitch.on {

            defaults.setObject(nineSwitch.on, forKey: "remindermorning")

            let date = NSDate()
            let cal = NSCalendar.currentCalendar()
            cal.timeZone = NSCalendar.currentCalendar().timeZone
            let fireDate = cal.dateBySettingHour(9, minute: 0, second: 0, ofDate: date, options: NSCalendarOptions())

            morningNotification.alertBody = "Did you take your medication this morning?"
            morningNotification.repeatInterval = NSCalendarUnit.Day
            morningNotification.fireDate = fireDate
            morningNotification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(morningNotification)
        } else {

            defaults.removeObjectForKey("remindermorning")
            UIApplication.sharedApplication().cancelLocalNotification(morningNotification)
        }
    }

    var afternoonNotification = UILocalNotification()
    @IBAction func twoTapped(sender: UISwitch) {

        if twoSwitch.on {

            defaults.setObject(twoSwitch.on, forKey: "reminderafternoon")

            let date = NSDate()
            let cal = NSCalendar.currentCalendar()
            cal.timeZone = NSCalendar.currentCalendar().timeZone
            let fireDate = cal.dateBySettingHour(14, minute: 0, second: 0, ofDate: date, options: NSCalendarOptions())

            afternoonNotification.alertBody = "Did you take your medication this afternoon?"
            afternoonNotification.repeatInterval = NSCalendarUnit.Day
            afternoonNotification.fireDate = fireDate
            afternoonNotification.soundName = UILocalNotificationDefaultSoundName

            UIApplication.sharedApplication().scheduleLocalNotification(afternoonNotification)
        } else {

            defaults.removeObjectForKey("reminderafternoon")
            UIApplication.sharedApplication().cancelLocalNotification(afternoonNotification)
        }
    }

    var eveninigNotification = UILocalNotification()
    @IBAction func sevenTapped(sender: UISwitch) {

        if sevenSwtich.on {

            defaults.setObject(sevenSwtich.on, forKey: "reminderevening")

            let date = NSDate()
            let cal = NSCalendar.currentCalendar()
            cal.timeZone = NSCalendar.currentCalendar().timeZone
            let fireDate = cal.dateBySettingHour(19, minute: 0, second: 0, ofDate: date, options: NSCalendarOptions())

            eveninigNotification.alertBody = "Did you take your medication this evening?"
            eveninigNotification.repeatInterval = NSCalendarUnit.Day
            eveninigNotification.fireDate = fireDate
            eveninigNotification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(eveninigNotification)
        } else {

            defaults.removeObjectForKey("reminderevening")
            UIApplication.sharedApplication().cancelLocalNotification(eveninigNotification)
        }
    }

    var bedtimeNotification = UILocalNotification()
    @IBAction func elevenTapped(sender: UISwitch) {

        if elevenSwtich.on {

            defaults.setObject(elevenSwtich.on, forKey: "reminderbedtime")

            let date = NSDate()
            let cal = NSCalendar.currentCalendar()
            cal.timeZone = NSCalendar.currentCalendar().timeZone
            let fireDate = cal.dateBySettingHour(23, minute: 0, second: 0, ofDate: date, options: NSCalendarOptions())

            bedtimeNotification.alertBody = "Did you take your medication before you go to bed?"
            bedtimeNotification.repeatInterval = NSCalendarUnit.Day
            bedtimeNotification.fireDate = fireDate
            bedtimeNotification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(bedtimeNotification)
        } else {

            defaults.removeObjectForKey("reminderbedtime")
            UIApplication.sharedApplication().cancelLocalNotification(bedtimeNotification)
        }
    }
}
