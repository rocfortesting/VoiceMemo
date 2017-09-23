//
//  ViewController.swift
//  VoiceMemo-iOS
//
//  Created by ROC Zhang on 2017/9/22.
//  Copyright © 2017年 Roc Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum State {
        case noPermission
        case normal
        case recording
        case recordFinished
        case recordSaved
        case playing
    }
    
    
    // MARK: UI Elements
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.font = .voiceMemoTitleFont
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        
        
        return label
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = .voiceMemoSubTitleFont
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    private lazy var playButton = PlayButton()
    
    private lazy var recordButton = RecordButton()
    
    
    // MARK: Data Elements
    
    private var currentState: State = .normal {
        didSet {
            toggleStateChanging()
        }
    }
    
    private var currentMemo: VoiceMemo?
    
    private lazy var timer: DispatchTimer = {
        let timer = DispatchTimer(with: .milliseconds(500), on: .global(), handler: {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.refreshTimerLabel()
            }
        })
        
        return timer
    }()
    
    
    // MARK: Life-Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        makeLayout()
        configButtonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AccessChecker.canAccessMicrophone { [weak self] (access) in
            guard let strongSelf = self else { return }
            
            if access {
                strongSelf.currentState = .normal
            } else {
                strongSelf.currentState = .noPermission
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Private Methods
    
    private func makeUI() {
        title = "Voice Memo"
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        
        let rightNavigationItem = UIBarButtonItem(title: "列表", style: .plain, target: self, action: #selector(rightNavigationItemBeenTapped(_:)))
        navigationItem.rightBarButtonItem = rightNavigationItem
        
        view.backgroundColor = .voiceMemoBackgroundColor
        view.addSubview(timerLabel)
        view.addSubview(stateLabel)
        view.addSubview(recordButton)
        view.addSubview(playButton)
        
        playButton.isHidden = true
    }
    
    private func makeLayout() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            timerLabel.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: Configs.UI.basicLeading),
            timerLabel.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -Configs.UI.basicLeading),
            timerLabel.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -175),
            
            stateLabel.leadingAnchor.constraint(equalTo: timerLabel.leadingAnchor),
            stateLabel.trailingAnchor.constraint(equalTo: timerLabel.trailingAnchor),
            stateLabel.bottomAnchor.constraint(equalTo: timerLabel.topAnchor),
            
            recordButton.widthAnchor.constraint(equalToConstant: 65),
            recordButton.heightAnchor.constraint(equalToConstant: 65),
            recordButton.leadingAnchor.constraint(equalTo: timerLabel.leadingAnchor),
            recordButton.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -70),
            
            playButton.widthAnchor.constraint(equalToConstant: 45),
            playButton.heightAnchor.constraint(equalToConstant: 45),
            playButton.leadingAnchor.constraint(equalTo: recordButton.trailingAnchor, constant: 25),
            playButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor)
            ])
    }
    
    private func configButtonActions() {
        recordButton.touchesBeginAction = { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.startRecord()
        }
        
        recordButton.touchesEndedAction = { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.stopRecord()
        }
        
        playButton.touchesBeginAction = { [weak self] in
            guard let strongSelf = self else { return }
            
            if strongSelf.currentState == .playing {
                strongSelf.stopPlay()
            } else {
                strongSelf.playMemo()
            }
        }
    }
    
    private func refreshTimerLabel() {
        switch currentState {
        case .recording:
            timerLabel.text = AudioManager.shared.currentRecoderString
        case .playing:
            timerLabel.text = AudioManager.shared.currentPlayerString
        default:
            break
        }
    }
    
    private func startRecord() {
        do {
            try AudioManager.record()
            timer.start()
            currentState = .recording
        } catch {
            printLog(error.localizedDescription)
        }
    }
    
    private func stopRecord() {
        AudioManager.stopRecord { [weak self] (flag) in
            guard flag, let strongSelf = self else { return }
            
            strongSelf.currentState = .recordFinished
            strongSelf.askForSaveMemo()
        }
        timer.stop()
    }
    
    private func askForSaveMemo() {
        let alert = UIAlertController(title: "是否保存？", message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "是", style: .default) { [weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.saveMemo()
        }
        let cancelAction = UIAlertAction(title: "否", style: .cancel) { [weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.currentState = .normal
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func saveMemo() {
        AudioManager.saveRecordToDocument { [weak self] (flag, memo) in
            guard let strongSelf = self else { return }
            guard flag, let memo = memo else { return }
            strongSelf.currentMemo = memo
            
            let context = CoreDataManager.shared.persistentContainer.viewContext
            if LocalMemo.saveMemo(from: memo, in: context) {
                strongSelf.currentState = .recordSaved
            }
        }
    }
    
    private func playMemo() {
        guard let memo = currentMemo else { return }
        do {
            try AudioManager.play(with: memo, completion: {[weak self] (flag) in
                guard let strongSelf = self else { return }
                
                strongSelf.currentState = .recordSaved
                strongSelf.timer.stop()
            })
            timer.start()
            currentState = .playing
        } catch {
            printLog(error.localizedDescription)
        }
    }
    
    private func stopPlay() {
        AudioManager.stopPlay()
        timer.stop()
        currentState = .recordSaved
    }
    
    private func toggleStateChanging() {
        switch currentState {
        case .noPermission:
            stateLabel.text = "没有权限，请前往设置打开"
            recordButton.isHidden = true
            playButton.isHidden = true
            
        case .normal:
            stateLabel.text = "按住录音按钮开始录音"
            recordButton.isHidden = false
            playButton.isHidden = true
            timerLabel.text = "00:00:00"
            
        case .recording:
            stateLabel.text = "录音中，松手结束录音"
            playButton.isHidden = true
            
        case .recordFinished:
            stateLabel.text = "录音结束"
            playButton.isHidden = true
            
        case .recordSaved:
            stateLabel.text = "已保存，单击播放录音"
            playButton.isHidden = false
            playButton.state = .tapToPlay
            timerLabel.text = "00:00:00"
            
        case .playing:
            stateLabel.text = "录音回放中"
            playButton.state = .tapToStop
        }
    }
    
    
    // MARK: Actions
    
    @objc private func rightNavigationItemBeenTapped(_ sender: UIBarButtonItem) {
        let vc = VoiceMemoListViewController()
        show(vc, sender: nil)
    }

}

