'use client'

import {useTaskContract} from '@/hooks/use-task-contract'
import dayjs from 'dayjs'
import {useEffect, useState} from 'react'
import {zeroAddress} from 'viem'
// import {useAccount} from 'wagmi'

import {Loader} from 'lucide-react'

interface MissionFormProps {
  onClose: () => void
}

interface FormData {
  name: string
  description: string
  startTime: number
  endTime: number
  stakingAmount: string
  participantsLimit: number
  stakingToken: `0x${string}`
  taskType: number
}

export default function MissionForm({onClose}: MissionFormProps) {
  const [formData, setFormData] = useState<FormData>({
    name: '',
    description: '',
    startTime: 0,
    endTime: 0,
    stakingAmount: '',
    participantsLimit: 0,
    stakingToken: '0x',
    taskType: 0
  })
  const {useCreateTask} = useTaskContract()
  useCreateTask()
  const {createTask, isLoading, isSuccess} = useCreateTask()
  const account = {} //useAccount()
  // console.log("account", account);
  console.log('isLoading', isLoading)
  console.log('isSuccess', isSuccess)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()

    try {
      // TODO: Add API call to create mission
      if (account.address) {
        const params = {
          ...formData,
          endTime: dayjs(formData.endTime).valueOf() / 1000,
          startTime: dayjs(formData.startTime).valueOf() / 1000,
          stakingToken: zeroAddress,
          taskType: 0,
          hash: JSON.stringify({
            name: formData.name,
            description: formData.description
          })
        }
        console.log('params', params)
        const res = await createTask(params).catch((e) => {
          console.log('e', e)
        })
      }

      console.log('Form submitted:', formData)
      // onClose();
    } catch (error) {
      console.error('Error creating mission:', error)
    }
  }

  const handleChange = (
    e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>
  ) => {
    const {name, value} = e.target
    setFormData((prev) => ({...prev, [name]: value}))
  }

  useEffect(() => {
    if (isSuccess) {
      onClose()
    }
    return () => {}
  }, [isSuccess])

  return (
    <form onSubmit={handleSubmit} className="p-6 space-y-6">
      <div className="space-y-4">
        <div>
          <label
            htmlFor="name"
            className="block text-sm font-medium text-purple-300 mb-2">
            Mission Name
          </label>
          <input
            type="text"
            id="name"
            name="name"
            value={formData.name}
            onChange={handleChange}
            className="w-full bg-indigo-900/50 rounded-lg px-4 py-2 text-white placeholder-purple-400 focus:ring-2 focus:ring-purple-500 focus:outline-none"
            placeholder="Enter mission name"
            required
          />
        </div>

        <div>
          <label
            htmlFor="description"
            className="block text-sm font-medium text-purple-300 mb-2">
            Mission Description
          </label>
          <textarea
            id="description"
            name="description"
            value={formData.description}
            onChange={handleChange}
            className="w-full h-32 bg-indigo-900/50 rounded-lg px-4 py-2 text-white placeholder-purple-400 focus:ring-2 focus:ring-purple-500 focus:outline-none"
            placeholder="Describe your mission"
            required
          />
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label
              htmlFor="startTime"
              className="block text-sm font-medium text-purple-300 mb-2">
              Start Date
            </label>
            <input
              type="datetime-local"
              id="startTime"
              name="startTime"
              value={formData.startTime}
              onChange={handleChange}
              className="w-full bg-indigo-900/50 rounded-lg px-4 py-2 text-white focus:ring-2 focus:ring-purple-500 focus:outline-none"
              required
            />
          </div>

          <div>
            <label
              htmlFor="endTime"
              className="block text-sm font-medium text-purple-300 mb-2">
              End Date
            </label>
            <input
              type="datetime-local"
              id="endTime"
              name="endTime"
              value={formData.endTime}
              onChange={handleChange}
              className="w-full bg-indigo-900/50 rounded-lg px-4 py-2 text-white focus:ring-2 focus:ring-purple-500 focus:outline-none"
              required
            />
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label
              htmlFor="stakingAmount"
              className="block text-sm font-medium text-purple-300 mb-2">
              Stake Amount (WEI)
            </label>
            <input
              type="number"
              id="stakingAmount"
              name="stakingAmount"
              value={formData.stakingAmount}
              onChange={handleChange}
              className="w-full bg-indigo-900/50 rounded-lg px-4 py-2 text-white placeholder-purple-400 focus:ring-2 focus:ring-purple-500 focus:outline-none"
              placeholder="Enter stake amount"
              min="0"
              required
            />
          </div>

          <div>
            <label
              htmlFor="participantsLimit"
              className="block text-sm font-medium text-purple-300 mb-2">
              Max Participants
            </label>
            <input
              type="number"
              id="participantsLimit"
              name="participantsLimit"
              value={formData.participantsLimit}
              onChange={handleChange}
              className="w-full bg-indigo-900/50 rounded-lg px-4 py-2 text-white placeholder-purple-400 focus:ring-2 focus:ring-purple-500 focus:outline-none"
              placeholder="Enter max participants"
              min="1"
              required
            />
          </div>
        </div>
      </div>

      <div className="flex justify-end gap-4">
        <button
          type="button"
          onClick={onClose}
          className="px-6 py-2 rounded-full hover:bg-purple-800 transition-colors">
          Cancel
        </button>
        <button
          type="submit"
          className="px-6 py-2 bg-gradient-to-r from-purple-500 to-indigo-500 hover:from-purple-600 hover:to-indigo-600 rounded-full font-semibold transition-colors">
          {isLoading ? <Loader className="animate-spin" /> : 'Create Mission'}
        </button>
      </div>
    </form>
  )
}
