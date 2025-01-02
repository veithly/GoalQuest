'use client'

import {ArrowLeft, MoreHorizontal} from 'lucide-react'
import Link from 'next/link'
import ShareButton from '../ShareButton'

export default function MissionDetailsHeader() {
  return (
    <div className="bg-gradient-to-r from-indigo-900 to-purple-900 p-4">
      <div className="container mx-auto flex items-center justify-between">
        <div className="flex items-center space-x-4">
          <Link
            href="/"
            className="p-2 hover:bg-purple-800 rounded-full transition-colors">
            <ArrowLeft className="w-6 h-6" />
          </Link>
          <h1 className="text-xl font-bold">30 Days of Coding</h1>
        </div>
        <div className="flex items-center space-x-2">
          <ShareButton />
          <button className="p-2 hover:bg-purple-800 rounded-full transition-colors">
            <MoreHorizontal className="w-5 h-5" />
          </button>
        </div>
      </div>
    </div>
  )
}
